import XCTest
import NIO
@testable import CloudPubSub
import CloudTrace

private var callback: ((IncomingPlainTextMessage) async throws -> Void)?

private struct CallbackHandler: Handler {

    let subscription = Subscription(name: "test", topic: Topics.test)

    func handle(message: Incoming, context: any Context) async throws {
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
        try await PushSubscriber.shared.bootstrap(eventLoopGroup: eventLoopGroup)
        try await Publisher.shared.bootstrap(eventLoopGroup: eventLoopGroup)

        // Prepare
        let expectation = self.expectation(description: "Received message")
        var receivedMessage: IncomingPlainTextMessage?

        callback = { message in
            receivedMessage = message
            expectation.fulfill()
        }

        // Recive message
        let handler = CallbackHandler()
        try await PushSubscriber.register(handler: handler)

        // Publish message
        let publishedMessage = FakePushMessage(
            message: .init(
                messageId: "123",
                data: "Hello".data(using: .utf8)!,
                publishTime: Date(),
                attributes: [:]
            ),
            subscription: handler.subscription.id
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

        try await PushSubscriber.shared.shutdown()
    }

    func testParseIncoming() throws {
        let decoder = PushSubscriber.HTTPHandler.decoder

        do {
            let incoming = try decoder.decode(PushSubscriber.Incoming.self, from: """
{
  \"message\": {
    \"attributes\": {},
    \"data\": \"SGVq\",
    \"messageId\": \"7893897826387963\",
    \"message_id\": \"7893897826387963\",
    \"publishTime\": \"2023-07-21T14:00:07Z\",
    \"publish_time\": \"2023-07-21T14:00:07Z\"
  },
  \"subscription\": \"projects/proj/subscriptions/sub\"
}
""".data(using: .utf8)!)
            XCTAssertEqual(incoming.message.data, "Hej".data(using: .utf8)!)
            XCTAssertEqual(incoming.message.id, "7893897826387963")
            XCTAssertEqual(incoming.message.published.timeIntervalSince1970, 1689948007.0)
        }
    }
}
