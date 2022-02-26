import XCTest
import NIO
import GCPPubSub

extension Subscription {

    static let test = Subscription(name: "test", topic: .test)
}

private struct CallbackHandler: SubscriptionHandler {

    let callback: (SubscriberMessage) async throws -> Void

    func handle(message: inout SubscriberMessage) async throws {
        try await callback(message)
    }
}

final class SubscriberTestCase: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try eventLoopGroup.syncShutdownGracefully()

        try await super.tearDown()
    }

    func testSubscribe() async throws {
        try await Subscriber.bootstrap(eventLoopGroup: eventLoopGroup)
        try await Publisher.bootstrap(eventLoopGroup: eventLoopGroup)

        // Prepare
        let expectation = self.expectation(description: "Received message")
        var receivedMessage: SubscriberMessage?

        let handler = CallbackHandler { message in
            receivedMessage = message
            expectation.fulfill()
        }

        // Recive message
        try await Subscriber.startPull(subscription: .test, handler: handler)

        // Publish message
        let publishedMessage = try! await Publisher.shared.publish(to: .test, data: "Hello".data(using: .utf8)!)

        // Wait
        await waitForExpectations(timeout: 60, handler: nil)

        // Assert
        XCTAssertNotNil(publishedMessage)
        XCTAssertNotNil(receivedMessage)
        XCTAssertEqual(publishedMessage.id, receivedMessage?.id)

        try await Subscriber.shutdown()
    }
}
