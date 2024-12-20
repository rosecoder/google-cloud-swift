import XCTest
@testable import CloudRedis

final class RedisGetTests: EmulatorTestCase {

    let existingKey: Key = "dw26cd"

    override func setUp() async throws {
        try await super.setUp()

        let user = User(email: "yay")
        try await Redis.set(key: existingKey, to: user)
    }

    // MARK: - Get

    func testGetExisting() async throws {
        let value = try await Redis.get(key: existingKey)
        XCTAssertEqual(value.string, "{\"email\":\"yay\"}")
    }

    func testNotFound() async throws {
        let value = try await Redis.get(key: "qgf7")
        XCTAssertNil(value.string)
    }

    func testGetExistingCustom() async throws {
        let userUnwrapped = try await Redis.get(User.self, key: existingKey)
        let user = try XCTUnwrap(userUnwrapped)
        XCTAssertEqual(user.email, "yay")
    }
}
