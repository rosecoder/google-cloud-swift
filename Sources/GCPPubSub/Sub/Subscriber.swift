import Foundation
import GRPC
import NIO
import Logging
import GCPCore

public final class Subscriber: Dependency {

    private static var _client: Google_Pubsub_V1_SubscriberAsyncClient?
    private static let logger = Logger(label: "Pub/Sub Subscriber")

    private static var client: Google_Pubsub_V1_SubscriberAsyncClient {
        guard let _client = _client else {
            fatalError("Must call Subscriber.bootstrap(eventLoopGroup:) first")
        }

        return _client
    }

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {

        // Emulator
        if let host = ProcessInfo.processInfo.environment["PUBSUB_EMULATOR_HOST"] {
            let components = host.components(separatedBy: ":")
            let port = Int(components[1])!

            let channel = ClientConnection
                .insecure(group: eventLoopGroup)
                .connect(host: components[0], port: port)

            self._client = .init(channel: channel)
        }

        // Production
        else {
            let channel = ClientConnection
                .usingTLSBackedByNIOSSL(on: eventLoopGroup)
                .connect(host: "pubsub.googleapis.com", port: 443)

            let accessToken = try await AccessToken(scopes: ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/pubsub"]).generate()
            let callOptions = CallOptions(
                customMetadata: ["authorization": "Bearer \(accessToken)"],
                timeLimit: .deadline(.distantFuture)
            )

            self._client = .init(channel: channel, defaultCallOptions: callOptions)
        }
    }

    // MARK: - Subscribe

    private static var runningPullTasks = [Task<Void, Error>]()

    public static func startPull(subscription: Subscription, handler: SubscriptionHandler) async throws {
        try await subscription.createIfNeeded(creation: client.createSubscription)

        runningPullTasks.append(Task {
            while !Task.isCancelled {
                try await singlePull(subscription: subscription, handler: handler)
            }
        })
    }

    // MARK: - Shutdown

    public static func shutdown() async {
        logger.info("Shutting down subscriptions...")

        runningPullTasks.forEach { $0.cancel() }
        for task in runningPullTasks {
            _ = await task.result
        }
    }

    // MARK: - Acknowledge

    private static func acknowledge(id: String, subscription: Subscription) async throws {
        _ = try await client.acknowledge(.with {
            $0.subscription = subscription.rawValue
            $0.ackIds = [id]
        })
    }

    // MARK: - Pull

    private static func singlePull(subscription: Subscription, handler: SubscriptionHandler) async throws {
        let response = try await client.pull(.with {
            $0.subscription = subscription.rawValue
            $0.maxMessages = 100
        })
        guard !response.receivedMessages.isEmpty else {
            return
        }

        logger.debug("Received messages: \(response.receivedMessages.count)")

        let tasks: [Task<Void, Error>] = response.receivedMessages.map { receivedMessage in
            Task {
                let rawMessage = receivedMessage.message
                let message = SubscriberMessage(
                    id: rawMessage.messageID,
                    published: rawMessage.publishTime.date,
                    data: rawMessage.data,
                    attributes: rawMessage.attributes
                )

                // Handle message
                logger.debug("Handling message", metadata: ["message-id": .string(rawMessage.messageID)])

                do {
                    try await handler.handle(message: message)
                } catch {
                    logger.error("Failed to handle message: \(error)", metadata: ["message-id": .string(rawMessage.messageID)])
                }

                do {
                    try await acknowledge(id: receivedMessage.ackID, subscription: subscription)
                } catch {
                    logger.error("Failed to acknowledge message: \(error)", metadata: ["message-id": .string(rawMessage.messageID)])
                }
            }
        }
        for task in tasks {
            _ = try await task.value
        }
    }
}
