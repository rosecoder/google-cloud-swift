import Foundation
import GCPLogging
import GCPTrace

private var _unsafeTerminateReferences = [((Int32) -> Task<Void, Never>)]()

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
                _unsafeTerminateReferences.forEach {
                    _ = $0(0)
                }
            }
        } else {
            logger.warning("Catching graceful termination twice. This is not recommended.")
        }

        _unsafeTerminateReferences.append(terminate)
    }

    /// Initializes gracefull termination task
    /// - Parameter exitCode: Exit code to terminate process with after shutdown completed.
    @discardableResult
    public func terminate(exitCode: Int32) -> Task<Void, Never> {
#if DEBUG
        logger.debug("Shutdown initialized. Terminating... 👋")
#else
        logger.info("Shutdown initialized. Terminating...")
#endif

        return Task(priority: .userInitiated) {

            // App
            do {
                try await shutdown()
            } catch {
                logger.critical("Error shutting down app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                exit(1)
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
                    exit(1)
                }
            }

            // Trace
#if !DEBUG
            do {
                try await Tracing.shutdown()
            } catch {
                logger.error("Error shutting down tracing: \(error)")
            }
#endif

            // Logging
#if !DEBUG
            logger.debug("Shutting down logging...")
            try! await GoogleCloudLogHandler.shutdown()
#endif

            // Just in case, hold on for 1 sec
            logger.debug("Delay shutting quickly...")
            try! await Task.sleep(nanoseconds: 1_000_000_000)

            // It's time
            exit(exitCode)
        }
    }
}
