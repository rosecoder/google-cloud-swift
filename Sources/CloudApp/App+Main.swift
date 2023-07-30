import Foundation
import Logging
import CloudErrorReporting
import CloudLogger
import CloudTrace
import CloudCore
import GRPC
import RetryableTask

extension App {

    public func initialize(bootstrap: () async throws -> Void = {}) async {
        _unsafeInitializedEventLoopGroup = eventLoopGroup

        // Logging
#if DEBUG
        LoggingSystem.bootstrap { label in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = logLevel
            return handler
        }
#else
        do {
            try GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
            LoggingSystem.bootstrap { label in
                var handler = GoogleCloudLogHandler(label: label)
                handler.logLevel = logLevel
                return handler
            }
        } catch {
            logger.critical("Logging failed to bootstrap: \(error)")
            await terminate(exitCode: 1)
        }
#endif
        _ = logger // Initializes default logger

        // Termination
        catchGracefulTermination()

        // Error reporting
#if !DEBUG
        do {
            try ErrorReporting.bootstrap(eventLoopGroup: eventLoopGroup)
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

        // Metrics
        // TODO: Implement

        // App dependencies
        for options in Self.dependencies {
            do {
                try await options.type.bootstrap(eventLoopGroup: eventLoopGroup)
            } catch {
                logger.warning("\(options.type) failed to bootstrap: \(error)")
            }
        }

        // App
        do {
            try await bootstrap()
        } catch {
            logger.critical("Error bootstrapping app", metadata: [
                "error": .string(String(describing: error)),
            ])
            await terminate(exitCode: 1)
        }

        // Readiness indication file
        if let path = ProcessInfo.processInfo.environment["READINESS_INDICATION_FILE"] {
            do {
                try Data([0x1]).write(to: URL(fileURLWithPath: path))
            } catch {
                logger.warning("Failed to write readiness indication file: \(error)")
            }
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
    public func processMain(bootstrap: @escaping () async throws -> Void = {}) {
        Task {
            // Retries
            DefaultRetryPolicy.retryPolicy = DelayedRetryPolicy(
                delay: 50_000_000, // 50 ms
                maxRetries: 1
            )
            
            // Init
            await initialize(bootstrap: bootstrap)
            
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

            await initialize(bootstrap: {
                _ = try await Server.insecure(group: eventLoopGroup)
                    .withServiceProviders(serviceProviders)
                    .bind(host: "0.0.0.0", port: port)
                    .get()

                try await bootstrap()
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
