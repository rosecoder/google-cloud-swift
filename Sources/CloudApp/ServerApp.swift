import Foundation
import GRPC
import RetryableTask

public protocol ServerApp: App {

    static var serviceProviders: [CallHandlerProvider] { get }
    static var defaultPort: Int { get }
}

extension ServerApp {

    /// Intiaizlies the app with all bootstrapping defined and starting the run loop.
    /// - Parameter boostrap: Additional bootstrapping work that should be done. This bootstrap is run last.
    ///
    /// Boostrapping order:
    /// - Logging
    /// - Error reporting
    /// - Tracing
    /// - Metrics
    /// - App dependencies
    /// - App (`bootstrap`-parameter)
    public static func main() {
        Task {
            // Retries
            DefaultRetryPolicy.retryPolicy = DelayedRetryPolicy(
                delay: 10_000_000, // 10 ms
                maxRetries: 1
            )

            // Init
            let port: Int
            if let rawPort = ProcessInfo.processInfo.environment["PORT"], let environmentPort = Int(rawPort) {
                port = environmentPort
            } else {
                port = defaultPort
            }

            await initialize(preBootstrap: {
                _ = try await Server.insecure(group: eventLoopGroup)
                    .withServiceProviders(serviceProviders)
                    .bind(host: "0.0.0.0", port: port)
                    .get()
            })

            // Ready!
#if DEBUG
            logger.debug("App running in debug on port \(port) 🚀")
#else
            logger.info("Bootstrap completed on port \(port)")
#endif
        }

        RunLoop.current.run()

        Task {
            await terminate(exitCode: 0)
        }
    }
}
