import XCTest
import NIO
import GCPPubSub
import GCPTrace

extension Topics {

    static let test = Topic<PlainTextMessage>(name: "test")
}

final class PublisherTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try eventLoopGroup.syncShutdownGracefully()

        try await super.tearDown()
    }

    func testPublish() async throws {
        try await Publisher.bootstrap(eventLoopGroup: eventLoopGroup)

        try await Publisher.publish(to: Topics.test, body: "Hello", context: context)
    }
}
