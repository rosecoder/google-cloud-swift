import Foundation
import Logging
import GCPErrorReporting
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
    /// This function will never return if `runLoop` for the app is not `.custom`.
    public func main(boostrap: @escaping () async throws -> Void = {}) {

        // Logging
#if DEBUG
        LoggingSystem.bootstrap {
            var handler = StreamLogHandler.standardOutput(label: $0)
            handler.logLevel = logLevel
            return handler
        }
#else
        GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
        LoggingSystem.bootstrap {
            var handler = GoogleCloudLogHandler(label: $0, resource: .autoResolve)
            handler.logLevel = logLevel
            return handler
        }
#endif
        _ = logger // Initializes default logger

        // Termination
        catchGracefulTermination()

        // Error reporting
#if !DEBUG
        ErrorReporting.bootstrap(eventLoopGroup: eventLoopGroup, resource: .autoResolve)
#endif

        Task {

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

        switch runLoop {
        case .current:
            RunLoop.current.run()
            terminate(exitCode: 0)
            
        case .custom:
            break
        }
    }
}
