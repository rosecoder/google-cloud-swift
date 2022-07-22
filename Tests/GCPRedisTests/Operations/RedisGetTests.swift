import XCTest
@testable import GCPRedis

final class RedisGetTests: EmulatorTestCase {

    let existingKey: GCPRedis.Key = "dw26cd"

    override func setUp() async throws {
        try await super.setUp()

        let user = User(email: "yay")
        try await Redis.set(key: existingKey, to: user, context: context)
    }

    // MARK: - Get

    func testGetExisting() async throws {
        let value = try await Redis.get(key: existingKey, context: context)
        XCTAssertEqual(value.string, "{\"email\":\"yay\"}")
    }

    func testNotFound() async throws {
        let value = try await Redis.get(key: "qgf7", context: context)
        XCTAssertNil(value.string)
    }

    func testGetExistingCustom() async throws {
        let userUnwrapped = try await Redis.get(User.self, key: existingKey, context: context)
        let user = try XCTUnwrap(userUnwrapped)
        XCTAssertEqual(user.email, "yay")
    }
}
