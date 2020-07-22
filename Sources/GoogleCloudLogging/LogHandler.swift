import Logging
import OAuth2
import GRPC
import NIO
import Foundation

public struct GoogleCloudLogHandler: LogHandler {

    public let label: String
    public let resource: Resource

    public var metadata: Logger.Metadata = [:]

    public var logLevel: Logger.Level

    public init(label: String, resource: Resource = .autoResolve, level: Logger.Level = .debug, metadata: Logger.Metadata = [:]) {
        self.label = label
        self.resource = resource
        self.metadata = metadata
        self.logLevel = level
    }

    // MARK: - Metadata

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    // MARK: - Log

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        let now = Date()
        let logName = resource.logName(label: label)

        var textPayload = message.description

        var labels: [String: String] = resource.entryLabels
        if let metadata = metadata {
            labels.reserveCapacity(metadata.count)
            for (key, value) in metadata {
                labels[key] = value.description
            }
        }

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
//                    $0.httpRequest = .with {
//                        $0.requestMethod = ""
//                    }
                }
            ]
        }

        _ = Self.rawClient.writeLogEntries(request).response
    }
}
