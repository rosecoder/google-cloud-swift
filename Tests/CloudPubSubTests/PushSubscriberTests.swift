import XCTest
import NIO
import CloudPubSub
import CloudTrace

private var callback: ((IncomingPlainTextMessage) async throws -> Void)?

private struct CallbackHandler: Handler {

    static let subscription = Subscription(name: "test", topic: Topics.test)

    let context: Context
    let message: PlainTextMessage.Incoming

    func handle() async throws {
        try await callback?(message)
    }
}

private struct FakePushMessage: Encodable {

    let message: Message
    let subscription: String

    struct Message: Encodable {

        let messageId: String
        let data: Data
        let publishTime: Date
        let attributes: [String: String]
    }
}

final class PushSubscriberTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        PushSubscriber.isDebugUsingPull = false
    }

    override func tearDown() async throws {
        try await eventLoopGroup.shutdownGracefully()

        PushSubscriber.isDebugUsingPull = true

        try await super.tearDown()
    }

    func testSubscribe() async throws {
        try await PushSubscriber.bootstrap(eventLoopGroup: eventLoopGroup)
        try await Publisher.bootstrap(eventLoopGroup: eventLoopGroup)

        // Prepare
        let expectation = self.expectation(description: "Received message")
        var receivedMessage: IncomingPlainTextMessage?

        callback = { message in
            receivedMessage = message
            expectation.fulfill()
        }

        // Recive message
        try await PushSubscriber.register(handler: CallbackHandler.self)

        // Publish message
        let publishedMessage = FakePushMessage(
            message: .init(
                messageId: "123",
                data: "Hello".data(using: .utf8)!,
                publishTime: Date(),
                attributes: [:]
            ),
            subscription: CallbackHandler.subscription.id
        )
        do {
            let encoder = JSONEncoder()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)

            var urlRequest = URLRequest(url: URL(string: "http://localhost:8080/")!)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = try encoder.encode(publishedMessage)
            _ = try await URLSession.shared.data(for: urlRequest)
        }

        // Wait
        await fulfillment(of: [expectation], timeout: 10)

        // Assert
        XCTAssertNotNil(publishedMessage)
        XCTAssertNotNil(receivedMessage)
        XCTAssertEqual(publishedMessage.message.messageId, receivedMessage?.id)
        XCTAssertEqual("Hello", receivedMessage?.body)

        try await PushSubscriber.shutdown()
    }
}
