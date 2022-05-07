import XCTest
@testable import GCPTrace

final class TraceIdentifierTests: XCTestCase {

    func testGenerate() {
        let id1 = Trace.Identifier()
        XCTAssert(id1.rawValue.0 != 0 || id1.rawValue.1 != 0)

        let id2 = Trace.Identifier()
        XCTAssertNotEqual(id1, id2)
    }

    func testStringEncode() {
        XCTAssertEqual(
            Trace.Identifier(rawValue: (59286721253214, 13759819252)).stringValue,
            "000035ebc3f5cf5e0000000334262df4"
        )
        XCTAssertEqual(
            Trace.Identifier(rawValue: (.max, .max)).stringValue,
            "ffffffffffffffffffffffffffffffff"
        )
    }

    func testStringDecode() {
        XCTAssertEqual(
            Trace.Identifier(stringValue: "000035ebc3f5cf5e0000000334262df4"),
            Trace.Identifier(rawValue: (59286721253214, 13759819252))
        )
        XCTAssertEqual(
            Trace.Identifier(stringValue: "ffffffffffffffffffffffffffffffff"),
            Trace.Identifier(rawValue: (.max, .max))
        )
        XCTAssertNil(
            Trace.Identifier(stringValue: "ff")
        )
        XCTAssertNil(
            Trace.Identifier(stringValue: "000035ebc3f5cfZZ0000000334262df4")
        )
        XCTAssertNil(
            Trace.Identifier(stringValue: "000035ebc3f5cf5e0000000334262dZZ")
        )
        XCTAssertNil(
            Trace.Identifier(stringValue: "00000000000000000000000000000000")
        )
        XCTAssertNil(
            Trace.Identifier(stringValue: "🎉🎉🎉🎉🎉🎉🎉🎉")
        )
    }
}
