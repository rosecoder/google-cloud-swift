import Foundation
import CloudLogger
import CloudTrace

private var _unsafeTerminateReferences = [((Int32) -> Task<Void, Never>)]()

extension App {

    static func catchGracefulTermination() {
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

        _unsafeTerminateReferences.append({ exitCode in
            Task {
                await terminate(exitCode: exitCode)
            }
        })
    }

    /// Initializes gracefull termination task
    /// - Parameter exitCode: Exit code to terminate process with after shutdown completed.
    public static func terminate(exitCode: Int32) async -> Never {
#if !DEBUG
        logger.debug("Shutdown initialized. Terminating...")
#endif

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
#if !DEBUG
        for dependency in Self.dependencies.reversed() {
            do {
                try await dependency.type.shared.shutdown()
            } catch {
                logger.error("Error shutting down app dependency, \(dependency.type): \(error)")
                hasFail = true
            }
        }
#endif

        // Trace
#if !DEBUG
        do {
            try await Tracing.shared.shutdown()
        } catch {
            logger.error("Error shutting down tracing: \(error)")
        }
#endif

        // Logging
#if !DEBUG
        try! await GoogleCloudLogging.shared.shutdown()
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
