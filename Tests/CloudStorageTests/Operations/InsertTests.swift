import XCTest
import CloudStorage

final class InsertTests: EmulatorTestCase {

    func testWriteSimpleTextObject() async throws {
        let bucket = Bucket(name: "google-cloud-swift-test")
        let object = Object(path: "\(#function)/test.txt")

        try await Storage.insert(
            data: "Hello world!".data(using: .utf8)!,
            contentType: "text/plain",
            object: object,
            in: bucket
        )
    }
}
