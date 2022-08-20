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
#if !DEBUG
        logger.debug("Shutdown initialized. Terminating...")
#endif

        return Task(priority: .userInitiated) {
            var hasFail = false

            // Readiness indication file
            if let path = ProcessInfo.processInfo.environment["READINESS_INDICATION_FILE"] {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    logger.warning("Failed to remove readiness indication file: \(error)")
                }
            }

            // App
            do {
                try await shutdown()
            } catch {
                logger.error("Error shutting down app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                hasFail = true
            }

            // App dependencies
            for dependency in Self.dependencies.reversed() {
                do {
                    try await dependency.type.shutdown()
                } catch {
                    logger.error("Error shutting down app dependency: \(dependency)", metadata: [
                        "error": .string(String(describing: error)),
                    ])
                    hasFail = true
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
            try! await GoogleCloudLogHandler.shutdown()
#endif

            // Just in case, hold on for 1 sec
            try! await Task.sleep(nanoseconds: 1_000_000_000)

            // It's time
            if hasFail && exitCode == 0 {
                exit(1)
            }
            exit(exitCode)
        }
    }
}
