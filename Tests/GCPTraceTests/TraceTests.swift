import XCTest
@testable import GCPTrace

final class TraceTests: XCTestCase {

    func testFromHeader() throws {
        let trace = try XCTUnwrap(Trace(headerValue: "000035ebc3f5cf5e0000000334262df4/000035ebc3f5cf5e;o=1", name: "GetTest"))

        XCTAssertEqual(trace.id, .init(rawValue: (59286721253214, 13759819252)))
        XCTAssertEqual(trace.spanID, .init(rawValue: 59286721253214))

        let rootSpan = try XCTUnwrap(trace.rootSpan)
        XCTAssertEqual(rootSpan.name, "GetTest")
    }

    func testFromHeaderInvalid() {
        XCTAssertNil(Trace(headerValue: "000035ebc3f5cf5e0000000334262df4/000035ebc3f5cf5e;o=0", name: "GetTest"))
        XCTAssertNil(Trace(headerValue: "000035ebc3f5cf5e0000000334262df4/000035ebc3f5cf5e", name: "GetTest"))
        XCTAssertNil(Trace(headerValue: "/;o=1", name: "GetTest"))
    }
}
