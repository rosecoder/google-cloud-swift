import XCTest
import NIO
import CloudPubSub
import CloudTrace

extension Topics {

    static let test = Topic<PlainTextMessage>(name: "test")
}

final class PublisherTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try await eventLoopGroup.shutdownGracefully()

        try await super.tearDown()
    }

    func testPublish() async throws {
        try await Publisher.shared.bootstrap(eventLoopGroup: eventLoopGroup)

        try await Publisher.publish(to: Topics.test, body: "Hello", context: context)
    }
}
