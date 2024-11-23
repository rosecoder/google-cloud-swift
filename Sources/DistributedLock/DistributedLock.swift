import Logging

public protocol DistributedLock: Sendable {

    func lock(key: String, logger: Logger) async throws
    func unlock(key: String, startedAt: ContinuousClock.Instant, logger: Logger) async throws
}
