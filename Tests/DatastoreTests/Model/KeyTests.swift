import XCTest
import Datastore

final class KeyTests: XCTestCase {

    // MARK: - Codable

    private func assertCodable<T: AnyKey>(source: T, file: StaticString = #file, line: UInt = #line) throws {
        let raw = try JSONEncoder().encode(source)
        let decoded = try JSONDecoder().decode(T.self, from: raw)
        XCTAssertEqual(decoded, source, file: file, line: line)
    }

    func testCoding_IndependentKey() throws {
        try assertCodable(source: IndependentKeyEntity.Key.named("c"))
    }

    func testCoding_IndependentNamespaceableKey() throws {
        try assertCodable(source: IndependentNamespaceableKeyEntity.Key.named("c", namespace: .test1))
    }

    func testCoding_ParentableKey() throws {
        try assertCodable(source: ParentableKeyEntity.Key.named("c", parent: .named("p")))
    }

    func testCoding_ParentableNamespaceableKey() throws {
        try assertCodable(source: ParentableNamespaceableKeyEntity.Key.named("c", parent: .named("p", namespace: .test1), namespace: .test1))
    }

    // MARK: - CustomDebugStringConvertible

    func testDescription_IndependentKey() throws {
        XCTAssertEqual(
            IndependentKeyEntity.Key.named("c").debugDescription,
            ".Testttt-IndependentKeyEntity:\"c\""
        )
    }

    func testDescription_IndependentNamespaceableKey() throws {
        XCTAssertEqual(
            IndependentNamespaceableKeyEntity.Key.named("c", namespace: .test1).debugDescription,
            "test1.Testttt-IndependentNamespaceableKeyEntity:\"c\""
        )
    }

    func testDescription_ParentableKey() throws {
        XCTAssertEqual(
            ParentableKeyEntity.Key.named("c", parent: .named("p")).debugDescription,
            ".Testttt-IndependentKeyEntity:\"p\".Testttt-ParentableKeyEntity:\"c\""
        )
    }

    func testDescription_ParentableNamespaceableKey() throws {
        XCTAssertEqual(
            ParentableNamespaceableKeyEntity.Key.named("c", parent: .named("p", namespace: .test1), namespace: .test1).debugDescription,
            "test1.Testttt-IndependentNamespaceableKeyEntity:\"p\".Testttt-ParentableNamespaceableKeyEntity:\"c\""
        )
    }
}
