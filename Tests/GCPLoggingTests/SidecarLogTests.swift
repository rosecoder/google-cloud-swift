import XCTest
@testable import GCPLogging
@testable import Logging

final class SidecarLogTests: XCTestCase {

    func testFormat() async throws {
        let log = SidecarLog(
            date: Date(),
            level: .info,
            message: "Test",
            metadata: [
                "key": .string("value"),
            ],
            source: "logging.test",
            file: "test.swift",
            function: "testFormat",
            line: 32
        )

        let data = try log.outputData()

        let dictionaryUnwrapped = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let dictionary = try XCTUnwrap(dictionaryUnwrapped)

        XCTAssertNotNil(dictionary["time"] as? String)
        XCTAssertEqual(dictionary["severity"] as? String, "INFO")
        XCTAssertEqual(dictionary["messageText"] as? String, "logging.test: Test")
        XCTAssertEqual(dictionary["message"] as? String, "testFormat test.swift:32")
        XCTAssertEqual(dictionary["context"] as? [String: String], ["key": "value"])
    }

    func testFormatNoMetadata() async throws {
        let log = SidecarLog(
            date: Date(),
            level: .info,
            message: "Test",
            metadata: nil,
            source: "logging.test",
            file: "test.swift",
            function: "testFormat",
            line: 32
        )

        let data = try log.outputData()

        let dictionaryUnwrapped = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let dictionary = try XCTUnwrap(dictionaryUnwrapped)

        XCTAssertEqual(dictionary["context"] as? [String: String], [:])
    }

    func testNosmoke() async throws {
        for level in Logger.Level.allCases {
            try SidecarLog(
                date: Date(),
                level: level,
                message: "Test",
                metadata: [
                    "key": .string("value"),
                ],
                source: "logging.test",
                file: "test.swift",
                function: "testFormat",
                line: 32
            ).write()
        }
    }
}
