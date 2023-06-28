import XCTest
@testable import Trace

final class CodableTests: XCTestCase {

    func testCodableTraceFull() throws {
        let trace = Trace(named: "codable-test", kind: .producer, attributes: [
            "attr1": "yo",
            "attr2": 1,
            "attr3": false,
        ])
        let span = trace.span(named: "span-1", kind: .producer, attributes: [
            "attr1": "hello",
            "attr2": 2,
            "attr3": true,
        ])

        let dataTrace = try JSONEncoder().encode(trace)
        let dataSpan = try JSONEncoder().encode(span)

        let decodedTrace = try JSONDecoder().decode(Trace.self, from: dataTrace)
        let decodedSpan = try JSONDecoder().decode(Span.self, from: dataSpan)

        XCTAssertEqual(trace.id, decodedTrace.id)
        XCTAssertEqual(trace.rootSpan, decodedTrace.rootSpan)
        XCTAssertEqual(trace.spanID, decodedTrace.spanID)

        XCTAssertEqual(span.traceID, decodedSpan.traceID)
        XCTAssertEqual(span.parentID, decodedSpan.parentID)
        XCTAssertEqual(span.sameProcessAsParent, decodedSpan.sameProcessAsParent)
        XCTAssertEqual(span.id, decodedSpan.id)
        XCTAssertEqual(span.name, decodedSpan.name)
        XCTAssertEqual(span.attributes.mapValues({ $0._codableValue }), decodedSpan.attributes.mapValues({ $0._codableValue }))
        XCTAssertEqual(span.started, decodedSpan.started)
        XCTAssertEqual(span.ended, decodedSpan.ended)
        XCTAssertEqual(span.status, decodedSpan.status)
        XCTAssertEqual(span.kind, decodedSpan.kind)
    }
}
