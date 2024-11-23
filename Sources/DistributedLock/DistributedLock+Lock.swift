import Tracing
import Logging

extension DistributedLock {

    @discardableResult
    public func withLock<Result: Sendable>(
        _ key: String,
        isolation: isolated(any Actor)? = #isolation,
        operation: () async throws -> Result
    ) async throws -> Result {
        let logger = Logger(label: "distributed-lock")

        // Lock
        let start = ContinuousClock.Instant.now
        try await withSpan("lock-wait") { span in
            span.attributes["key"] = key

            try await lock(key: key, logger: logger)
        }

        // Unlock async after return
        defer {
            Task {
                do {
                    try await unlock(key: key, startedAt: start, logger: logger)
                } catch {
                    logger.error("Failed to unlock lock: \(key) \(error)")
                }
            }
        }

        // Perform operation
        return try await operation()
    }
}
