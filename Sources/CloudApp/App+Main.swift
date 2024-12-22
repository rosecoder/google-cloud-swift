import Foundation
import Logging
import Tracing
import CloudCore
import RetryableTask
import ServiceLifecycle
import GoogleCloudServiceContext

extension App {

#if DEBUG
    static var configureForProduction: Bool { false }
#else
    static var configureForProduction: Bool { true }
#endif

    public static func main() async throws {
        let serviceContextResolverService = initializeServiceContextResolver()
        let logService = initializeLogging()

        var logger = Logger(label: "app.main")
        logger.logLevel = logLevel

        let services: [ServiceGroupConfiguration.ServiceConfiguration?] = [
            serviceContextResolverService,
            logService,
            tracingService(logger: logger),
        ] + (try await self.services())

        let serviceGroup = ServiceGroup(configuration: ServiceGroupConfiguration(
            services: services.compactMap { $0 },
            gracefulShutdownSignals: [.sigint, .sigterm],
            logger: logger
        ))

        try await serviceGroup.run()
    }
}
