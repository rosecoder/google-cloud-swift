import Foundation
import CloudTrace
import RediStack

extension Redis {

    private static let retryAttempts: UInt8 = 50
    private static let timeoutMiliseconds = 30_000 // 30 sec
    private static let minimumRetryDelayNanoseconds: UInt64 = 50_000_000 // 50 ms
    private static let maximumRetryDelayNanoseconds: UInt64 = 500_000_000 // 500 ms

    public enum LockError: Error {
        case waitTimeout
    }

    public static func lock<Result>(
        key: String,
        context: Context,
        closure: () async throws -> Result
    ) async throws -> Result {
        var waitSpan = context.trace?.span(named: "lock-wait", kind: .client, attributes: [
            "redis/key": key,
        ])

        let key = "lock/" + key
        let value: String = ProcessInfo.processInfo.environment["KUBERNETES_POD_NAME"] ?? String(Int32.random(in: Int32.min..<Int32.max))

        // Set lock
        let overestimatedSetDate = Date()
        do {
            try await setLock(key: key, value: value, context: context)
        } catch {
            waitSpan?.end(error: error)
            throw error
        }

        // Done waiting
        waitSpan?.end(statusCode: .ok)

        // Delete lock when done
        defer {
            let duration = Date().timeIntervalSince1970 - overestimatedSetDate.timeIntervalSince1970
            if duration < TimeInterval(timeoutMiliseconds) / 1_000 {
                Task {
                    do {
                        try await shared.ensureConnection(context: context)
                        _ = try await shared.connection.delete(RedisKey(key)).get()
                    } catch {
                        context.logger.error("Failed to delete Redis lock: \(key) \(error)")
                    }
                }
            } else {
                context.logger.error("Lock execution took longer than timeout: \(key)")
            }
        }

        // Perform action
        return try await closure()
    }

    private static func setLock(key: String, value: String, tryCount: UInt8 = 0, context: Context) async throws {
        try await shared.ensureConnection(context: context)
        let wasSet = try await shared.connection.set(RedisKey(key), to: value, onCondition: .keyDoesNotExist, expiration: .milliseconds(timeoutMiliseconds)).get()
        if wasSet == .ok {
            return
        }

        guard tryCount != retryAttempts else {
            throw LockError.waitTimeout
        }

        let waitDuration = (minimumRetryDelayNanoseconds..<maximumRetryDelayNanoseconds).randomElement()!

        context.logger.debug("Lock \(key) is locked. Retry in \(waitDuration)ns.")
        try await Task.sleep(nanoseconds: waitDuration)

        try await setLock(key: key, value: value, tryCount: tryCount + 1, context: context)
  }
}
