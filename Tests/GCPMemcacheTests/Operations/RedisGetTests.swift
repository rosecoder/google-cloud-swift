import XCTest
import GCPMemcache

final class RedisGetTests: EmulatorTestCase {

    let existingKey: GCPMemcache.Key = "dw26cd"

    override func setUp() async throws {
        try await super.setUp()

        let user = User(email: "yay")
        try await Redis.set(key: existingKey, to: user, trace: nil)
    }

    // MARK: - Get

    func testGetExisting() async throws {
        let value = try await Redis.get(key: existingKey, trace: nil)
        XCTAssertEqual(value.string, "{\"email\":\"yay\"}")
    }

    func testNotFound() async throws {
        let value = try await Redis.get(key: "qgf7", trace: nil)
        XCTAssertNil(value.string)
    }

    func testGetExistingCustom() async throws {
        let userUnwrapped = try await Redis.get(User.self, key: existingKey, trace: nil)
        let user = try XCTUnwrap(userUnwrapped)
        XCTAssertEqual(user.email, "yay")
    }
}
