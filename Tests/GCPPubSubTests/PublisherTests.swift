import XCTest
import NIO
import GCPPubSub

struct Message: Codable {

    let text: String
}

extension Topic {

    static let test = Topic(name: "test")
}

final class PublisherTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try eventLoopGroup.syncShutdownGracefully()

        try await super.tearDown()
    }

    func testPublish() async throws {
        Publisher.bootstrap(eventLoopGroup: eventLoopGroup)

        try await Publisher.publish(to: .test, data: "Hello".data(using: .utf8)!)
    }
}
