import XCTest
import NIO
@testable import CloudStorage
import CloudCore
import CloudTrace

final class SigningTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    private let object = Object(path: "testSignForWrite/\(UUID().uuidString).txt")
    private let bucket = Bucket(name: "<#bucket name#>")

    override func setUp() async throws {
        try await super.setUp()

        let serviceAccountData = try Data(contentsOf: URL(fileURLWithPath:  "<#service account url#>"))
        let serviceAccount = try JSONDecoder().decode(ServiceAccount.self, from: serviceAccountData)

        await ServiceAccountCoordinator.shared.use(custom: serviceAccount)
    }

    func testSignForWrite() async throws {

        // Generate URL for writing
        let urlForWrite = try await Storage.generateSignedURL(for: .writing, object: object, in: bucket, context: context)

        // Upload a plain text file
        let boundary = "__GC-SWIFT_BOUNDARY__"

        var request = URLRequest(url: URL(string: urlForWrite)!)
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var requestBody = ""
        requestBody.append("--\(boundary)\r\n")
        requestBody.append("Content-Disposition: form-data; name=\"file\"\r\n")
        requestBody.append("Content-Type: text/plain\r\n\r\n")
        requestBody.append("Hello world!")
        requestBody.append("\r\n")
        requestBody.append("--\(boundary)--\r\n")
        request.httpBody = Data(requestBody.utf8)

        let (_, response) = try await URLSession.shared.data(for: request)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 204)

        // Generate URL for reading
        let urlForRead = try await Storage.generateSignedURL(for: .reading, object: object, in: bucket, context: context)

        // Assert that uploaded is same as read
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlForRead)!)
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, "Hello world!")
    }
}
