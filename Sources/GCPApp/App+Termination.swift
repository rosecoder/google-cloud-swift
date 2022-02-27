import Foundation
import GCPLogging

private var isReadyToDie = false
private var _sigintSource: DispatchSourceSignal?

extension App {

    func catchGracefulTermination() {
        let rawSignal: Int32
#if DEBUG
        rawSignal = SIGINT
#else
        rawSignal = SIGTERM
#endif
        signal(rawSignal, SIG_IGN)

        let sigintSource = DispatchSource.makeSignalSource(signal: rawSignal, queue: .main)
        sigintSource.setEventHandler {
            terminate(exitCode: 0)
        }
        sigintSource.resume()

        // Keep strong reference to signal source
        _sigintSource = sigintSource
    }

    public func terminate(exitCode: Int32) -> Never {
        #if DEBUG
        logger.debug("Shutdown initialized. Terminating... 👋")
        #else
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
            try! await GoogleCloudLogHandler.shutdown()
            #endif

            // Just in case, hold on for 1 sec
            try! await Task.sleep(nanoseconds: 1_000_000_000)

            // It's time
            isReadyToDie = true
        }

        let runLoop = RunLoop.current
        while !isReadyToDie && runLoop.run(mode: .default, before: .distantFuture) {}

        exit(exitCode)
    }
}
