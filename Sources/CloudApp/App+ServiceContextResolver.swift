import ServiceLifecycle
import GoogleCloudServiceContext

extension App {

    static func initializeServiceContextResolver() -> ServiceGroupConfiguration.ServiceConfiguration?  {
        guard configureForProduction else {
            return nil
        }
        return .init(service: GoogleServiceContextResolver())
    }
}
