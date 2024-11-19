import Foundation
import CloudCore
import NIO
import AsyncHTTPClient
import GoogleCloudAuth
import Logging
import Synchronization
import ServiceLifecycle

public struct ErrorReportingLogHandler: LogHandler {

    public let service: ErrorReportingService
    public var metadata: Logger.Metadata = [:]
    public var logLevel: Logger.Level

    public init(logLevel: Logger.Level = .error, service: ErrorReportingService) {
        self.logLevel = logLevel
        self.service = service
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let date = Date()
        Task(priority: .background) {
            do {
                try await service.report(
                    date: date,
                    message: message.description,
                    source: source,
                    file: file,
                    function: function,
                    line: line
                )
            } catch {
                print("Error reporting error: \(error)")
            }
        }
    }
}
