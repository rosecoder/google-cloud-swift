import Logging
import GRPC
import NIO
import Foundation
import CloudCore
import CloudErrorReporting

public struct GoogleCloudLogHandler: LogHandler {

    public enum Method {
        case rpc
        case sidecar
    }

    public static var preferredMethod: Method = .sidecar

    // MARK: - LogHandler implementation

    public let label: String

    public var metadata: Logger.Metadata = [:]
    public var metadataProvider: Logger.MetadataProvider?

    public var logLevel: Logger.Level

    public init(label: String, level: Logger.Level = .debug, metadata: Logger.Metadata = [:], metadataProvider: Logger.MetadataProvider? = nil) {
        self.label = label
        self.metadata = metadata
        self.logLevel = level
        self.metadataProvider = metadataProvider
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        let now = Date()

        Self.lastLogTask = Task {
            var labels: [String: String] = Environment.current.entryLabels

            // Existing metdata
            var trace: String?
            var spanID: String?
            labels.reserveCapacity(self.metadata.count)
            for (key, value) in self.metadata {
                if key == LogMetadataKeys.trace {
                    trace = value.description
                    continue
                }
                if key == LogMetadataKeys.spanID {
                    spanID = value.description
                    continue
                }
                labels[key] = value.description
            }

            // New metdata
            if let metadata = metadata {
                labels.reserveCapacity(metadata.count)
                for (key, value) in metadata {
                    labels[key] = value.description
                }
            }
            if let metadataProvider = metadataProvider {
                let metadata = metadataProvider.get()
                labels.reserveCapacity(metadata.count)
                for (key, value) in metadata {
                    labels[key] = value.description
                }
            }

            switch Self.preferredMethod {
            case .rpc:
                do {
                    try await logViaRPC(now: now, labels: labels, trace: trace, spanID: spanID, level: level, message: message, source: source, file: file, function: function, line: line)
                } catch {
                    // Using forceable tries below.
                    // If fallback fails this is a critical issue and the app should be terminated on error.

                    // First, log the error resulting in create failure
                    try! SidecarLog(
                        date: Date(),
                        level: .error,
                        message: "Error creating log entry: \(error)",
                        labels: [:],
                        source: "logging.log",
                        trace: trace,
                        spanID: spanID,
                        file: #file,
                        function: #function,
                        line: #line
                    ).write()

                    try! logViaSidecar(now: now, labels: labels, trace: trace, spanID: spanID, level: level, message: message, source: source, file: file, function: function, line: line)
                }
            case .sidecar:
                try logViaSidecar(now: now, labels: labels, trace: trace, spanID: spanID, level: level, message: message, source: source, file: file, function: function, line: line)
            }

            // Report to error reporting if error
            do {
                switch level {
                case .error, .critical:
                    try await ErrorReporting.report(
                        date: now,
                        message: message.description,
                        source: source,
                        file: file,
                        function: function,
                        line: line
                    )
                case .trace, .debug, .info, .notice, .warning:
                    break
                }
            } catch {
                log(
                    level: .warning,
                    message: "Error reporting error to error reporting: \(error)",
                    metadata: nil,
                    source: source,
                    file: file,
                    function: function,
                    line: line
                )
            }
        }
    }

    // MARK: - Internal

    /// Last task for publishing logging to GCP. Intended only for internal use while testing.
    static var lastLogTask: Task<(), Error>?

    private func logViaRPC(now: Date, labels: [String: String], trace: String?, spanID: String?, level: Logger.Level, message: Logger.Message, source: String, file: String, function: String, line: UInt) async throws {
        let environment = Environment.current
        let logName = environment.logName(label: label)
        var textPayload = message.description
        if level >= .error {
            let formattedLines: [String] = Thread.callStackSymbols
                .compactMap { line in
                    let components = line.components(separatedBy: " ").filter({ !$0.isEmpty })
                    guard components.count >= 6
                        else { return nil }

                    let method = components[3..<(components.count - 2)].joined()
                    return "\tat " + method + "(:" + components.last! + ")"
                }

            textPayload += "\n" + formattedLines.joined(separator: "\n")
        }

        let request = Google_Logging_V2_WriteLogEntriesRequest.with {
            $0.logName = logName
            $0.resource = .with {
                $0.type = environment.type
                $0.labels = environment.labels
            }
            $0.entries = [
                .with {
                    $0.timestamp = .init(date: now)
                    $0.severity = .init(level: level)
                    $0.sourceLocation = .with {
                        $0.file = file
                        $0.line = Int64(line)
                        $0.function = function
                    }
                    $0.textPayload = textPayload
                    $0.labels = labels

                    if let trace, let spanID {
                        $0.trace = trace
                        $0.spanID = spanID
                        $0.traceSampled = true
                    }
                }
            ]
        }
        try await Self._client!.ensureAuthentication(authorization: Self.authorization)
        _ = try await Self._client!.writeLogEntries(request)
    }

    private func logViaSidecar(now: Date, labels: [String: String], trace: String?, spanID: String?, level: Logger.Level, message: Logger.Message, source: String, file: String, function: String, line: UInt) throws {
        try SidecarLog(
            date: now,
            level: level,
            message: message,
            labels: labels,
            source: source,
            trace: trace,
            spanID: spanID,
            file: file,
            function: function,
            line: line
        ).write()
    }
}
