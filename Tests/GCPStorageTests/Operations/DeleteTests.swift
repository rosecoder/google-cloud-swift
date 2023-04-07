import XCTest
import GCPStorage
import GCPTrace

final class DeleteTests: EmulatorTestCase {

    func testDeleteObject() async throws {
        let bucket = Bucket(name: "google-cloud-swift-test")
        let object = Object(path: "\(#function)/temp.txt")

        try await Storage.insert(
            data: "Hello world!".data(using: .utf8)!,
            contentType: "text/plain",
            object: object,
            in: bucket,
            context: context
        )

        try await Storage.delete(object: object, in: bucket, context: context)
    }
}
