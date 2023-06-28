import Foundation
import Logging

/// Log which is formatted to use a format parsable structured logging in GCP.
///
/// Note that this format is not well documented by Google.
struct SidecarLog: Encodable {

    let time: String
    let severity: String

    let messageText: String
    let message: String

    let context: [String: String]

    init(
        date: Date,
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
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

        self.messageText = "\(function) \(file):\(line)"
        self.message = "\(source): \(message.description)"

        self.context = metadata?.mapValues { $0.description } ?? [:]
    }

    // MARK: - Formatters

    private static let timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
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
