import Logging
import Metrics
import GoogleCloudMetrics
import ServiceLifecycle

extension App {

    static func metricsService(logger: Logger) -> ServiceGroupConfiguration.ServiceConfiguration?  {
        guard configureForProduction else {
            return nil
        }
        do {
            let factory = try GoogleCloudMetricsFactory()
            MetricsSystem.bootstrap(factory)
            return .init(service: factory)
        } catch {
            logger.warning("Metrics (optional) failed to bootstrap: \(error)")
            return nil
        }
    }
}
