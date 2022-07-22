import XCTest
import NIO
import GCPPubSub
import GCPTrace

private var callback: ((IncomingPlainTextMessage) async throws -> Void)?

private struct CallbackHandler: Handler {

    static let subscription = Subscription(name: "test", topic: Topics.test)

    let context: Context
    let message: PlainTextMessage.Incoming

    func handle() async throws {
        try await callback?(message)
    }
}

final class SubscriberTestCase: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try eventLoopGroup.syncShutdownGracefully()

        try await super.tearDown()
    }

    func testSubscribe() async throws {
        Subscriber.bootstrap(eventLoopGroup: eventLoopGroup)
        Publisher.bootstrap(eventLoopGroup: eventLoopGroup)

        // Prepare
        let expectation = self.expectation(description: "Received message")
        var receivedMessage: IncomingPlainTextMessage?

        callback = { message in
            receivedMessage = message
            expectation.fulfill()
        }

        // Recive message
        try await Subscriber.startPull(handler: CallbackHandler.self)

        // Publish message
        let publishedMessage = try await Publisher.publish(to: Topics.test, body: "Hello", context: context)

        // Wait
        await waitForExpectations(timeout: 60, handler: nil)

        // Assert
        XCTAssertNotNil(publishedMessage)
        XCTAssertNotNil(receivedMessage)
        XCTAssertEqual(publishedMessage.id, receivedMessage?.id)
        XCTAssertEqual("Hello", receivedMessage?.body)

        try await Subscriber.shutdown()
    }
}
