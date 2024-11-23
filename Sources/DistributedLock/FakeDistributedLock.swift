import Foundation
import Logging

public struct FakeDistributedLock: DistributedLock {

    private let _lock = NSLock()

    public init() {}

    public func lock(key: String, logger: Logger) {
        _lock.lock()
    }

    public func unlock(key: String, startedAt: ContinuousClock.Instant, logger: Logger) {
        _lock.unlock()
    }
}
