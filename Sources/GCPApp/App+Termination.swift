import Foundation
import GCPLogging

private var isReadyToDie = false

extension App {

    public func terminate(exitCode: Int32) -> Never {
        logger.debug("Shutdown initialized. Terminating...")

        Task {

            // App
            do {
                try await shutdown()
            } catch {
                logger.critical("Error shutting down app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                terminate(exitCode: 1)
            }

            // App dependencies
            for dependency in dependencies.reversed() {
                do {
                    try await dependency.shutdown()
                } catch {
                    logger.critical("Error shutting down app dependency: \(dependency)", metadata: [
                        "error": .string(String(describing: error)),
                    ])
                }
            }

            // Metrics
            // TODO: Implement

            // Tracing
            // TODO: Implement

            // Error reporting
            // TODO: Implement

            // Logging
            #if !DEBUG
            try await GoogleCloudLogHandler.shutdown()
            #endif

            // It's time
            isReadyToDie = true
        }

        let runLoop = RunLoop.current
        while !isReadyToDie && runLoop.run(mode: .default, before: .distantFuture) {}

        exit(exitCode)
    }
}
