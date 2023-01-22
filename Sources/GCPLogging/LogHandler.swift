import Logging
import GRPC
import NIO
import Foundation
import GCPCore
import GCPErrorReporting

public struct GoogleCloudLogHandler: LogHandler {

    // MARK: - LogHandler implementation

    public let label: String
    public let resource: Resource

    public var metadata: Logger.Metadata = [:]
    public var metadataProvider: Logger.MetadataProvider?

    public var logLevel: Logger.Level

    public init(label: String, resource: Resource = .autoResolve, level: Logger.Level = .debug, metadata: Logger.Metadata = [:], metadataProvider: Logger.MetadataProvider? = nil) {
        self.label = label
        self.resource = resource
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
        let logName = resource.logName(label: label)

        var labels: [String: String] = resource.entryLabels

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

        // Payload
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
                $0.type = resource.rawValue
                $0.labels = resource.labels
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

                    if let trace = trace, let spanID = spanID {
                        $0.trace = trace
                        $0.spanID = spanID
                        $0.traceSampled = true
                    }
                }
            ]
        }

        Self.lastLogTask = Task {
            do {
                try await Self._client.ensureAuthentication(authorization: Self.authorization)
                _ = try await Self._client.writeLogEntries(request)
            } catch {

                // Using forceable tries below.
                // If fallback fails this is a critical issue and the app should be terminated on error.

                // First, log the error resulting in create failure
                try! SidecarLog(
                    date: Date(),
                    level: .error,
                    message: "Error creating log entry: \(error)",
                    metadata: nil,
                    source: "logging.log",
                    file: #file,
                    function: #function,
                    line: #line
                ).write()

                // Log the log which failed
                try! SidecarLog(
                    date: now,
                    level: level,
                    message: message,
                    metadata: metadata,
                    source: source,
                    file: file,
                    function: function,
                    line: line
                ).write()
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
}
