import XCTest
@testable import GCPTrace

final class SpanIdentifierTests: XCTestCase {

    func testGenerate() {
        let id1 = Span.Identifier()
        XCTAssertNotEqual(id1.rawValue, 0)

        let id2 = Span.Identifier()
        XCTAssertNotEqual(id1, id2)
    }

    func testStringValue() {
        XCTAssertEqual(
            Span.Identifier(rawValue: 59286721253214).stringValue,
            "000035ebc3f5cf5e"
        )
        XCTAssertEqual(
            Span.Identifier(rawValue: .max).stringValue,
            "ffffffffffffffff"
        )
    }
}
