import Foundation
@preconcurrency import RediStack
import DistributedLock
import Logging

public final class RedisLock: DistributedLock {

    let redis: Redis

    public init(redis: Redis) {
        self.redis = redis
    }

    private let retryAttempts: UInt8 = 50
    private let timeoutSeconds: Int = 30 // 30 sec
    private let minimumRetryDelayNanoseconds: UInt64 = 50_000_000 // 50 ms
    private let maximumRetryDelayNanoseconds: UInt64 = 500_000_000 // 500 ms

    public enum LockError: Error {
        case waitTimeout
    }

    public func lock(key: String, logger: Logger) async throws {
        let value: String = ProcessInfo.processInfo.environment["KUBERNETES_POD_NAME"] ?? String(Int32.random(in: Int32.min..<Int32.max))
        try await setLock(key: key, value: value, logger: logger)
    }

    private func setLock(key: String, value: String, tryCount: UInt8 = 0, logger: Logger) async throws {
        let connection = try await redis.ensureConnection()
        let wasSet = try await connection.set(redisKey(key), to: value, onCondition: .keyDoesNotExist, expiration: .milliseconds(timeoutSeconds)).get()
        if wasSet == .ok {
            return
        }

        guard tryCount != retryAttempts else {
            throw LockError.waitTimeout
        }

        let waitDuration = (minimumRetryDelayNanoseconds..<maximumRetryDelayNanoseconds).randomElement()!

        logger.debug("Lock \(key) is locked. Retry in \(waitDuration)ns.")
        try await Task.sleep(nanoseconds: waitDuration)

        try await setLock(key: key, value: value, tryCount: tryCount + 1, logger: logger)
  }

    public func unlock(key: String, startedAt: ContinuousClock.Instant, logger: Logger) async throws {
        let endedAt = ContinuousClock.Instant.now
        let duration = endedAt - startedAt
        guard duration.components.seconds < timeoutSeconds else {
            logger.error("Lock execution took longer than timeout: \(key)")
            return
        }
        let connection = try await redis.ensureConnection()
        _ = try await connection.delete(redisKey(key)).get()
    }

    private func redisKey(_ key: String) -> RedisKey {
        RedisKey("lock/" + key)
    }
}
