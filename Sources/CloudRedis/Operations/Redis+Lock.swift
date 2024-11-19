import Foundation
@preconcurrency import RediStack
import Tracing

extension Redis {

    private var retryAttempts: UInt8 { 50 }
    private var timeoutMilliseconds: Int { 30_000 } // 30 sec
    private var minimumRetryDelayNanoseconds: UInt64 { 50_000_000 } // 50 ms
    private var maximumRetryDelayNanoseconds: UInt64 { 500_000_000 } // 500 ms

    public enum LockError: Error {
        case waitTimeout
    }

    public func lock<Result: Sendable>(
        key: String,
        closure: () async throws -> Result
    ) async throws -> Result {
        let waitSpan = startSpan("lock-wait", ofKind: .client)
        waitSpan.attributes["redis/key"] = key

        let key = "lock/" + key
        let value: String = ProcessInfo.processInfo.environment["KUBERNETES_POD_NAME"] ?? String(Int32.random(in: Int32.min..<Int32.max))

        // Set lock
        let overestimatedSetDate = Date()
        do {
            try await setLock(key: key, value: value)
        } catch {
            waitSpan.recordError(error)
            waitSpan.end()
            throw error
        }

        // Done waiting
        waitSpan.setStatus(.init(code: .ok))
        waitSpan.end()

        // Delete lock when done
        defer {
            let duration = Date().timeIntervalSince1970 - overestimatedSetDate.timeIntervalSince1970
            if duration < TimeInterval(timeoutMilliseconds) / 1_000 {
                Task {
                    do {
                        let connection = try await ensureConnection()
                        _ = try await connection.delete(RedisKey(key)).get()
                    } catch {
                        logger.error("Failed to delete Redis lock: \(key) \(error)")
                    }
                }
            } else {
                logger.error("Lock execution took longer than timeout: \(key)")
            }
        }

        // Perform action
        return try await closure()
    }

    private func setLock(key: String, value: String, tryCount: UInt8 = 0) async throws {
        let connection = try await ensureConnection()
        let wasSet = try await connection.set(RedisKey(key), to: value, onCondition: .keyDoesNotExist, expiration: .milliseconds(timeoutMilliseconds)).get()
        if wasSet == .ok {
            return
        }

        guard tryCount != retryAttempts else {
            throw LockError.waitTimeout
        }

        let waitDuration = (minimumRetryDelayNanoseconds..<maximumRetryDelayNanoseconds).randomElement()!

        logger.debug("Lock \(key) is locked. Retry in \(waitDuration)ns.")
        try await Task.sleep(nanoseconds: waitDuration)

        try await setLock(key: key, value: value, tryCount: tryCount + 1)
  }
}
