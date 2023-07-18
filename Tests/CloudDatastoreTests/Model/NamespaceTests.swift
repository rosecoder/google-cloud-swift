import XCTest
@testable import CloudDatastore

final class NamespaceTests: XCTestCase {

    let aNamespace = Namespace(rawValue: "testing")

    // MARK: - Codable

    func testCodable() throws {
        let data = try JSONEncoder().encode(aNamespace)

        let decoded = try JSONDecoder().decode(Namespace.self, from: data)
        XCTAssertEqual(aNamespace, decoded)
    }

    // MARK: - CustomStringConvertible

    func testCustomStringConvertible() {
        XCTAssertEqual("testing", aNamespace.description)
    }

    // MARK: - CustomDebugStringConvertible

    func testCustomDebugStringConvertible() {
        XCTAssertEqual("testing", aNamespace.debugDescription)
    }
}
