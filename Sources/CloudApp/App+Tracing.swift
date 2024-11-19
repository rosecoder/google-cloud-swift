import Logging
import Tracing
import GoogleCloudTracing
import ServiceLifecycle

extension App {

    static func tracingService(logger: Logger) -> ServiceGroupConfiguration.ServiceConfiguration?  {
        guard configureForProduction else {
            return nil
        }
        do {
            let tracer = try GoogleCloudTracer()
            InstrumentationSystem.bootstrap(tracer)
            return .init(service: tracer)
        } catch {
            logger.warning("Tracer (optional) failed to bootstrap: \(error)")
            return nil
        }
    }
}
