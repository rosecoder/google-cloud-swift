import Foundation
import Logging
import CloudErrorReporting
import CloudLogger
import CloudTrace
import CloudCore
import RetryableTask

extension App {

    public static func initialize(preBootstrap: () async throws -> Void = {}) async {
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
                try await options.type.shared.bootstrap(eventLoopGroup: eventLoopGroup)
            } catch {
                logger.warning("\(options.type) failed to bootstrap: \(error)")
            }
        }

        // App
        do {
            try await preBootstrap()
            try await self.bootstrap()
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
}
