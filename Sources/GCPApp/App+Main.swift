import Foundation
import Logging
import GCPErrorReporting
import GCPLogging
import GCPTrace

private enum InitializeMode {
    case singleRun
    case runLoop
}

extension App {

    private func initialize(mode: InitializeMode, bootstrap: @escaping () async throws -> Void = {}) {

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

        // Trace
#if !DEBUG
        Tracing.bootstrap(eventLoopGroup: eventLoopGroup)
#endif

        Task {

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
                    return
                }
            }

            // Ready for action?
            switch mode {
            case .runLoop:
                break
            case .singleRun:
                logger.info("Bootstrap completed")
            }

            // App
            do {
                try await bootstrap()
            } catch {
                logger.critical("Error bootstrapping app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                terminate(exitCode: 1)
                return
            }

            // Ready!
            switch mode {
            case .runLoop:
#if DEBUG
                logger.debug("App running in debug 🚀")
#else
                logger.info("Bootstrap completed")
#endif
            case .singleRun:
                terminate(exitCode: 0)
            }
        }

        RunLoop.current.run()

        terminate(exitCode: 0)
    }

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
    public func main(bootstrap: @escaping () async throws -> Void = {}) {
        initialize(mode: .runLoop, bootstrap: bootstrap)
    }

    /// Intiaizlies the app with all bootstrapping defined for a single action run. After this the app is terminated with exit code 0.
    /// - Parameter action: Action to run after bootstrap.
    ///
    /// Boostrapping order:
    /// - Logging
    /// - Error reporting
    /// - Tracing
    /// - Metrics
    /// - App dependencies
    public func run(action: @escaping () async throws -> Void = {}) {
        initialize(mode: .singleRun, bootstrap: action)
    }
}
