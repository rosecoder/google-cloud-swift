import XCTest
import CloudDatastore

final class PutTests: EmulatorTestCase {

    func testPutNewWithIncompleteKey() async throws {
        var user = User(key: .incomplete, email: "testing")
        try await Datastore.put(entity: &user)

        switch user.key.id {
        case .uniq(let id):
            XCTAssertGreaterThan(id, 0)
        default:
            XCTFail("Key is not set: \(user.key)")
        }

        let wrappedPutUser: User? = try await Datastore.getEntity(key: user.key)
        let putUser = try XCTUnwrap(wrappedPutUser)
        XCTAssertEqual(putUser, user)
    }

    func testPutNewWithUniqKey() async throws {
        let key = User.Key.uniq(235798)

        let exists = try await Datastore.containsEntity(key: key)
        XCTAssertFalse(exists, "Precondition: User should not exist before test starts.")

        var user = User(key: key, email: "testing")
        try await Datastore.put(entity: &user)
        XCTAssertEqual(user.key, key)

        let wrappedPutUser: User? = try await Datastore.getEntity(key: user.key)
        let putUser = try XCTUnwrap(wrappedPutUser)
        XCTAssertEqual(putUser, user)
    }

    func testPutNewWithNamedKey() async throws {
        let key = User.Key.named("zg4bi")

        let exists = try await Datastore.containsEntity(key: key)
        XCTAssertFalse(exists, "Precondition: User should not exist before test starts.")

        var user = User(key: key, email: "testing")
        try await Datastore.put(entity: &user)
        XCTAssertEqual(user.key, key)

        let wrappedPutUser: User? = try await Datastore.getEntity(key: user.key)
        let putUser = try XCTUnwrap(wrappedPutUser)
        XCTAssertEqual(putUser, user)
    }
}
