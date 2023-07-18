import XCTest
@testable import CloudTrace

final class TruncatableStringTests: XCTestCase {

    typealias TruncatableString = Google_Devtools_Cloudtrace_V2_TruncatableString

    func testNoTruncation() {
        do {
            let string = TruncatableString("test", limit: 100)
            XCTAssertEqual(string.value, "test")
            XCTAssertEqual(string.truncatedByteCount, 0)
        }
        do {
            let string = TruncatableString("test 🎉", limit: 100)
            XCTAssertEqual(string.value, "test 🎉")
            XCTAssertEqual(string.truncatedByteCount, 0)
        }
    }

    func testTruncation() {
        do {
            let string = TruncatableString("123456789", limit: 4)
            XCTAssertEqual(string.value, "1234")
            XCTAssertEqual(string.truncatedByteCount, 5)
        }
        do {
            let string = TruncatableString("123🎉", limit: 4)
            XCTAssertEqual(string.value, "123")
            XCTAssertEqual(string.truncatedByteCount, Int32("🎉".utf8.count))
        }
    }
}
