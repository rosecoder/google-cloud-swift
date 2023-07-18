import XCTest
@testable import CloudLogger
@testable import Logging

final class SidecarLogTests: XCTestCase {

    func testFormat() async throws {
        let log = SidecarLog(
            date: Date(),
            level: .info,
            message: "Test",
            labels: [
                "key": "value",
            ],
            source: "logging.test",
            trace: nil,
            spanID: nil,
            file: "test.swift",
            function: "testFormat",
            line: 32
        )

        let data = try log.outputData()

        let dictionaryUnwrapped = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let dictionary = try XCTUnwrap(dictionaryUnwrapped)

        XCTAssertNotNil(dictionary["time"] as? String)
        XCTAssertEqual(dictionary["severity"] as? String, "INFO")
        XCTAssertEqual(dictionary["message"] as? String, "Test")
        XCTAssertEqual(dictionary["logging.googleapis.com/labels"] as? [String: String], ["key": "value", "logger": "logging.test"])
    }

    func testNosmoke() async throws {
        for level in Logger.Level.allCases {
            try SidecarLog(
                date: Date(),
                level: level,
                message: "Test",
                labels: [
                    "key": "value",
                ],
                source: "logging.test",
                trace: "tracer",
                spanID: "spaner",
                file: "test.swift",
                function: "testFormat",
                line: 32
            ).write()
        }
    }
}
