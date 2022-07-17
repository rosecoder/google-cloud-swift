import XCTest
@testable import GCPRedis

final class LockTests: EmulatorTestCase {

    func testLock() async throws {
        let lockKey = "testing"

        typealias ReturnType = (id: UInt8, start: Date, end: Date)

        let task1 = Task.detached { () -> ReturnType in
            return try await Redis.lock(key: lockKey, trace: nil) { () -> ReturnType in
                let start = Date()
                try await Task.sleep(nanoseconds: 500_000_000) // 500ms
                return (1, start, Date())
            }
        }
        try await Task.sleep(nanoseconds: 1_000_000) // 1ms
        let task2 = Task.detached { () -> ReturnType in
            return try await Redis.lock(key: lockKey, trace: nil) { () -> ReturnType in
                let start = Date()
                return (2, start, Date())
            }
        }

        let result1 = try await task1.value
        let result2 = try await task2.value

        XCTAssertEqual(result1.id, 1)
        XCTAssertEqual(result2.id, 2)

        XCTAssertLessThan(result1.start, result1.end)
        XCTAssertGreaterThanOrEqual(result2.start, result1.end)
    }
}
