import XCTest
@testable import CloudTrace

final class TraceTests: XCTestCase {

    func testFromHeader() throws {
        let trace = try XCTUnwrap(Trace(headerValue: "000035ebc3f5cf5e0000000334262df4/000035ebc3f5cf5e;o=1"))

        XCTAssertEqual(trace.id, .init(rawValue: (59286721253214, 13759819252)))
        XCTAssertEqual(trace.spanID, .init(rawValue: 59286721253214))
    }

    func testFromHeaderInvalid() {
        XCTAssertNil(Trace(headerValue: "000035ebc3f5cf5e0000000334262df4/000035ebc3f5cf5e;o=0"))
        XCTAssertNil(Trace(headerValue: "000035ebc3f5cf5e0000000334262df4/000035ebc3f5cf5e"))
        XCTAssertNil(Trace(headerValue: "/;o=1"))
    }
}
