import XCTest
@testable import GCPDatastore

final class IDTests: XCTestCase {

    // MARK: - Codable

    func testCodableUniq() throws {
        let encodedID = ID.uniq(123)
        let data = try JSONEncoder().encode(encodedID)

        let decodedID = try JSONDecoder().decode(ID.self, from: data)
        XCTAssertEqual(encodedID, decodedID, "IDs should be equal after encode and decode")
    }

    func testCodableNamed() throws {
        let encodedID = ID.named("123")
        let data = try JSONEncoder().encode(encodedID)

        let decodedID = try JSONDecoder().decode(ID.self, from: data)
        XCTAssertEqual(encodedID, decodedID, "IDs should be equal after encode and decode")
    }

    func testCodableIncomplete() throws {
        let encodedID = ID.incomplete
        let data = try JSONEncoder().encode(encodedID)

        let decodedID = try JSONDecoder().decode(ID.self, from: data)
        XCTAssertEqual(encodedID, decodedID, "IDs should be equal after encode and decode")
    }

    // MARK: - CustomStringConvertible

    func testCustomStringConvertible() {
        XCTAssertEqual("123", ID.uniq(123).description)
        XCTAssertEqual("123", ID.named("123").description)
        XCTAssertEqual("", ID.incomplete.description)
    }

    // MARK: - CustomDebugStringConvertible

    func testCustomDebugStringConvertible() {
        XCTAssertEqual("123", ID.uniq(123).debugDescription)
        XCTAssertEqual("\"123\"", ID.named("123").debugDescription)
        XCTAssertEqual("<incomplete>", ID.incomplete.debugDescription)
    }
}
