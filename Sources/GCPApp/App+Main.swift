import Foundation
import Logging
import GCPErrorReporting
import GCPLogging
import GCPTrace
import GRPC

extension App {

    public func initialize(bootstrap: @escaping () async throws -> Void = {}, completion: @escaping () async throws -> Void) {

        // Logging
#if DEBUG
        LoggingSystem.bootstrap {
            var handler = StreamLogHandler.standardOutput(label: $0)
            handler.logLevel = logLevel
            return handler
        }
#else
        do {
            try GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
            LoggingSystem.bootstrap {
                var handler = GoogleCloudLogHandler(label: $0, resource: .autoResolve)
                handler.logLevel = logLevel
                return handler
            }
        } catch {
            logger.critical("Logging failed to bootstrap: \(error)")
            terminate(exitCode: 1)
            return
        }
#endif
        _ = logger // Initializes default logger

        // Termination
        catchGracefulTermination()

        // Error reporting
#if !DEBUG
        do {
            try ErrorReporting.bootstrap(eventLoopGroup: eventLoopGroup, resource: .autoResolve)
        } catch {
            logger.warning("ErrorReporting (optional) failed to bootstrap: \(error)")
        }
#endif

        // Trace
#if !DEBUG
        do {
            try Tracing.bootstrap(eventLoopGroup: eventLoopGroup)
        } catch {
            logger.warning("Tracing (optional) failed to bootstrap: \(error)")
        }
#endif

        Task {

            // Metrics
            // TODO: Implement

            // App dependencies
            for options in Self.dependencies {
                do {
                    try await options.type.bootstrap(eventLoopGroup: eventLoopGroup)
                } catch {
                    if options.isRequired {
                        logger.critical("\(options.type) failed to bootstrap: \(error)")
                        terminate(exitCode: 1)
                        return
                    }
                    logger.warning("\(options.type) (optional) failed to bootstrap: \(error)")
                }
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

            // Readiness indication file
            if let path = ProcessInfo.processInfo.environment["READINESS_INDICATION_FILE"] {
                do {
                    try Data([0x1]).write(to: URL(fileURLWithPath: path))
                } catch {
                    logger.warning("Failed to write readiness indication file: \(error)")
                }
            }

            // Ready!
            try await completion()
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
    public func processMain(bootstrap: @escaping () async throws -> Void = {}) {
        initialize(bootstrap: bootstrap) {
#if DEBUG
            logger.debug("App running in debug 🚀")
#else
            logger.info("Bootstrap completed")
#endif
        }
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
    public func serverMain(
        serviceProviders: [CallHandlerProvider],
        defaultPort: Int,
        bootstrap: @escaping () async throws -> Void = {}
    ) {
        let port: Int
        if let rawPort = ProcessInfo.processInfo.environment["PORT"], let environmentPort = Int(rawPort) {
            port = environmentPort
        } else {
            port = defaultPort
        }

        initialize(bootstrap: {
            _ = try await Server.insecure(group: eventLoopGroup)
                .withServiceProviders(serviceProviders)
                .bind(host: "0.0.0.0", port: port)
                .get()

            try await bootstrap()
        }, completion: {
#if DEBUG
            logger.debug("App running in debug on port \(port) 🚀")
#else
            logger.info("Bootstrap completed on port \(port)")
#endif
        })
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
    public func serverMain(
        serviceProvider: CallHandlerProvider,
        defaultPort: Int,
        bootstrap: @escaping () async throws -> Void = {}
    ) {
        serverMain(serviceProviders: [serviceProvider], defaultPort: defaultPort, bootstrap: bootstrap)
    }
}
