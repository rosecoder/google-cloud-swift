import Foundation
import RetryableTask

public protocol ProcessApp: App {}

extension ProcessApp {

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
            await DefaultRetryPolicyConfiguration.shared.use(retryPolicy: DelayedRetryPolicy(
                delay: 50_000_000, // 50 ms
                maxRetries: 1
            ))

            // Init
            await initialize()

            // Ready!
#if DEBUG
            logger.debug("App running in debug 🚀")
#else
            logger.info("Bootstrap completed")
#endif
        }

        RunLoop.current.run()

        Task {
            await terminate(exitCode: 0)
        }
    }
}
