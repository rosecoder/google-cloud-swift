import XCTest
import NIO
import CloudPubSub

private nonisolated(unsafe) var callback: ((IncomingPlainTextMessage) async throws -> Void)?

private struct CallbackHandler: Handler {

    let subscription = Subscription(name: "test", topic: Topics.test)

    func handle(message: Incoming) async throws {
        try await callback?(message)
    }
}

final class PullSubscriberTestCase: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try await eventLoopGroup.shutdownGracefully()

        try await super.tearDown()
    }

    func testSubscribe() async throws {
        try await PullSubscriber.shared.bootstrap(eventLoopGroup: eventLoopGroup)
        try await Publisher.shared.bootstrap(eventLoopGroup: eventLoopGroup)

        // Prepare
        let expectation = self.expectation(description: "Received message")
        var receivedMessage: IncomingPlainTextMessage?

        callback = { message in
            receivedMessage = message
            expectation.fulfill()
        }

        // Recive message
        try await PullSubscriber.startPull(handler: CallbackHandler())

        // Publish message
        let publishedMessage = try await Publisher.publish(to: Topics.test, body: "Hello")

        // Wait
        await fulfillment(of: [expectation], timeout: 60)

        // Assert
        XCTAssertNotNil(publishedMessage)
        XCTAssertNotNil(receivedMessage)
        XCTAssertEqual(publishedMessage.id, receivedMessage?.id)
        XCTAssertEqual("Hello", receivedMessage?.body)

        try await PullSubscriber.shared.shutdown()
    }
}
