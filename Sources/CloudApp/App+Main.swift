import Foundation
import Logging
import ServiceLifecycle

extension App {

    public static func main() async throws {
        let telemetryServices = CloudBootstrap.bootstrap(logLevel: logLevel, metrics: metricsConfiguration)

        var logger = Logger(label: "app.main")
        logger.logLevel = logLevel

        let serviceGroup = ServiceGroup(configuration: ServiceGroupConfiguration(
            services: telemetryServices + (try await self.services()),
            gracefulShutdownSignals: [.sigint, .sigterm],
            logger: logger
        ))

        try await serviceGroup.run()
    }
}
