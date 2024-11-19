import Foundation
import Logging
import Tracing
import CloudErrorReporting
import GoogleCloudTracing
import CloudCore
import RetryableTask
import ServiceLifecycle

extension App {

#if DEBUG
    static var configureForProduction: Bool { false }
#else
    static var configureForProduction: Bool { true }
#endif

    public static func main() async throws {
        let logService = initializeLogging()

        var logger = Logger(label: "app.main")
        logger.logLevel = logLevel

        let services: [ServiceGroupConfiguration.ServiceConfiguration?] = [
            logService,
            tracingService(logger: logger),
        ] + self.services

        let serviceGroup = ServiceGroup(configuration: ServiceGroupConfiguration(
            services: services.compactMap { $0 },
            logger: logger
        ))

        try await serviceGroup.run()
    }
}
