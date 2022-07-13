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

    func testStringDecode() {
        XCTAssertEqual(
            Span.Identifier(stringValue: "000035ebc3f5cf5e"),
            Span.Identifier(rawValue: 59286721253214)
        )
        XCTAssertEqual(
            Span.Identifier(stringValue: "ffffffffffffffff"),
            Span.Identifier(rawValue: .max)
        )
        XCTAssertNil(
            Span.Identifier(stringValue: "ff")
        )
        XCTAssertNil(
            Span.Identifier(stringValue: "000035ebc3f5cfZZ0000000334262df4")
        )
        XCTAssertNil(
            Span.Identifier(stringValue: "000035ebc3f5cf5e0000000334262dZZ")
        )
        XCTAssertNil(
            Span.Identifier(stringValue: "00000000000000000")
        )
        XCTAssertNil(
            Span.Identifier(stringValue: "🎉🎉🎉🎉🎉🎉🎉🎉")
        )
    }
}
