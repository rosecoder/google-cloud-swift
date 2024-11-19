import Foundation
import ServiceLifecycle
import Logging
import GoogleCloudLogging
import CloudErrorReporting

extension App {

    static func initializeLogging() -> ServiceGroupConfiguration.ServiceConfiguration? {
        let logLevel = self.logLevel

        if configureForProduction {
            let errorReportingService = ErrorReportingService()

            LoggingSystem.bootstrap { label in
                var logHandler = GoogleCloudLogHandler(label: label)
                logHandler.logLevel = logLevel

                var errorReportingHandler = ErrorReportingLogHandler(service: errorReportingService)
                errorReportingHandler.logLevel = .error

                return MultiplexLogHandler([
                    logHandler,
                ])
            }

            return .init(service: errorReportingService)
        }

        LoggingSystem.bootstrap { label in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = logLevel
            return handler
        }
        return nil
    }
}
