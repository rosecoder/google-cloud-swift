import XCTest
import GCPDatastore
import GCPTrace

final class GetTests: EmulatorTestCase {

    let existingUniqKey: User.Key = .uniq(35611)
    let existingNamedKey: User.Key = .named("zw48ad")

    override func setUp() async throws {
        try await super.setUp()

        var users: [User] = [
            User(key: existingUniqKey, email: "tester-uniq"),
            User(key: existingNamedKey, email: "tester-named")
        ]
        try await Datastore.put(entities: &users, context: context)
    }

    // MARK: - Get

    func testGetExistingWithUniqID() async throws {
        let userWrapped: User? = try await Datastore.getEntity(key: existingUniqKey, context: context)
        let user = try XCTUnwrap(userWrapped)
        XCTAssertEqual(user.email, "tester-uniq")
    }

    func testGetExistingWithNamedID() async throws {
        let userWrapped: User? = try await Datastore.getEntity(key: existingNamedKey, context: context)
        let user = try XCTUnwrap(userWrapped)
        XCTAssertEqual(user.email, "tester-named")
    }

    func testNotFound() async throws {
        let userMaybe: User? = try await Datastore.getEntity(key: .uniq(1294578), context: context)
        XCTAssertNil(userMaybe, "User should not exist")
    }

    // MARK: - Contains

    func testContainsExisting() async throws {
        let exists = try await Datastore.containsEntity(key: existingUniqKey, context: context)
        XCTAssertTrue(exists)
    }

    func testContainsNotExisting() async throws {
        let exists = try await Datastore.containsEntity(key: User.Key.uniq(15209152), context: context)
        XCTAssertFalse(exists)
    }
}
