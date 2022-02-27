import Foundation
import Logging
import GCPLogging

extension App {

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
    ///
    /// This function will never return due to the runloop and graceful termination taking over.
    public func main(boostrap: @escaping () async throws -> Void = {}) -> Never {
        catchGracefulTermination()

        Task {

            // Logging
            #if DEBUG
            LoggingSystem.bootstrap {
                var handler = StreamLogHandler.standardOutput(label: $0)
                handler.logLevel = logLevel
                return handler
            }
            #else
            try! await GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
            LoggingSystem.bootstrap {
                var handler = GoogleCloudLogHandler(label: $0, resource: .autoResolve)
                handler.logLevel = logLevel
                return handler
            }
            #endif

            // Error reporting
            // TODO: Implement

            // Tracing
            // TODO: Implement

            // Metrics
            // TODO: Implement

            // App dependencies
            for dependency in dependencies {
                do {
                    try await dependency.bootstrap(eventLoopGroup: eventLoopGroup)
                } catch {
                    logger.critical("Error bootstrapping app dependency: \(dependency)", metadata: [
                        "error": .string(String(describing: error)),
                    ])
                    terminate(exitCode: 1)
                }
            }

            // App
            do {
                try await boostrap()
            } catch {
                logger.critical("Error bootstrapping app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                terminate(exitCode: 1)
            }

            // Ready!
            #if DEBUG
            logger.debug("App running in debug 🚀")
            #else
            logger.info("Bootstrap completed")
            #endif
        }

        RunLoop.current.run()

        terminate(exitCode: 0)
    }
}
