import Foundation
import GCPLogging

private var isReadyToDie = false

private var _unsafeTerminateReferences = [((Int32) -> Never)]()

extension App {

    func catchGracefulTermination() {
        if _unsafeTerminateReferences.isEmpty {
            let rawSignal: Int32
#if DEBUG
            rawSignal = SIGINT
#else
            rawSignal = SIGTERM
#endif
            signal(rawSignal) { _ in
                _unsafeTerminateReferences.forEach { $0(0) }
            }
        }

        _unsafeTerminateReferences.append(terminate)
    }

    public func terminate(exitCode: Int32) -> Never {
        #if DEBUG
        logger.debug("Shutdown initialized. Terminating... 👋")
        #else
        print("Shutdown initialized. Terminating...") // debugging shutdown in production
        logger.info("Shutdown initialized. Terminating...")
        #endif

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
                logger.debug("Shutting down app dependency \(dependency)...")

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
            logger.debug("Shutting down logging...")
            try! await GoogleCloudLogHandler.shutdown()
            #endif

            // Just in case, hold on for 1 sec
            logger.debug("Delay shutting quickly...")
            try! await Task.sleep(nanoseconds: 1_000_000_000)

            // It's time
            isReadyToDie = true

            logger.debug("Shutdown completed.")
        }

        let runLoop = RunLoop.current
        while !isReadyToDie && runLoop.run(mode: .default, before: .distantFuture) {}

        exit(exitCode)
    }
}
