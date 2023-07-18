import Foundation
import Logging

/// Log which is formatted to use a format parsable structured logging in GCP.
///
/// https://cloud.google.com/logging/docs/structured-logging#special-payload-fields
struct SidecarLog: Encodable {

    let time: String
    let severity: String

    let message: String
    let labels: [String: String]

    let spanID: String?
    let trace: String?
    let traceSampled: Bool

    let sourceLocation: SourceLocation

    struct SourceLocation: Encodable {

        let file: String
        let line: String
        let function: String
    }

    init(
        date: Date,
        level: Logger.Level,
        message: Logger.Message,
        labels: [String: String],
        source: String,
        trace: String?,
        spanID: String?,
        file: String,
        function: String,
        line: UInt
    ) {
        self.time = Self.timeDateFormatter.string(from: date)

        switch level {
        case .critical:
            self.severity = "CRITICAL"
        case .trace:
            self.severity = "TRACE"
        case .debug:
            self.severity = "DEBUG"
        case .info:
            self.severity = "INFO"
        case .notice:
            self.severity = "NOTICE"
        case .warning:
            self.severity = "WARNING"
        case .error:
            self.severity = "ERROR"
        }

        self.message = message.description

        var labels = labels
        labels["logger"] = source
        self.labels = labels

        self.sourceLocation = .init(file: file, line: String(line), function: function)

        self.trace = trace
        self.spanID = spanID
        self.traceSampled = trace != nil
    }

    enum CodingKeys: String, CodingKey {
        case time
        case severity
        case message
        case labels = "logging.googleapis.com/labels"
        case sourceLocation = "logging.googleapis.com/sourceLocation"
        case spanID = "logging.googleapis.com/spanId"
        case trace = "logging.googleapis.com/trace"
        case traceSampled = "logging.googleapis.com/trace_sampled"
    }

    // MARK: - Formatters

    private static let timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }()

    // MARK: - Encoding

    func outputData() throws -> Data {
        try JSONEncoder().encode(self) + Data([0x0A]) // LF (newline) character
    }

    /// Writes out the log to stdout or stderr depending in log level.
    func write() throws {
        let data = try outputData()

        switch severity {
        case "ERROR", "CRITICAL":
            try FileHandle.standardError.write(contentsOf: data)
        default:
            try FileHandle.standardOutput.write(contentsOf: data)
        }
    }
}
