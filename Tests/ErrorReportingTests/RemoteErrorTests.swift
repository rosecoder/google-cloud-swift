import XCTest
@testable import ErrorReporting

final class RemoteErrorTests: XCTestCase {

    func testParseError() throws {
        let data = """
{
  "error": {
    "code": 400,
    "message": "Message cannot be empty.",
    "status": "INVALID_ARGUMENT"
  }
}
""".data(using: .utf8)!

        let error = try JSONDecoder().decode(RemoteError.self, from: data)

        XCTAssertEqual(error.code, "INVALID_ARGUMENT")
        XCTAssertEqual(error.message, "Message cannot be empty.")
    }
}
