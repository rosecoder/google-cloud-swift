import Foundation
import GRPC
import NIO
import Logging
import GCPCore

public final class Subscriber: Dependency {

    private static var _client: Google_Pubsub_V1_SubscriberAsyncClient?
    private static let logger = Logger(label: "pubsub.subscriber")

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
#if DEBUG
        try await subscription.createIfNeeded(creation: client.createSubscription)
#endif

        runningPullTasks.append(Task {
            while !Task.isCancelled {
                do {
                    try await singlePull(subscription: subscription, handler: handler)
                } catch {
                    logger.warning("Pull failed for \(subscription.name): \(error)")
                }
            }
        })

        logger.debug("Subscribed to \(subscription.name)")
    }

    // MARK: - Shutdown

    public static func shutdown() async throws {
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

    private static func unacknowledge(id: String, subscription: Subscription) async throws {
        _ = try await client.modifyAckDeadline(.with {
            $0.subscription = subscription.rawValue
            $0.ackIds = [id]
            $0.ackDeadlineSeconds = 0
        })
    }

    // MARK: - Pull

    private static func singlePull(subscription: Subscription, handler: SubscriptionHandler) async throws {
        let response = try await client.pull(.with {
            $0.subscription = subscription.rawValue
            $0.maxMessages = 100
        }, callOptions: .init(
            timeLimit: .deadline(.distantFuture)
        ))
        guard !response.receivedMessages.isEmpty else {
            return
        }

        logger.debug("Received \(response.receivedMessages.count) messages")

        let tasks: [Task<Void, Error>] = response.receivedMessages.map { receivedMessage in
            Task {
                let rawMessage = receivedMessage.message

                // Get a logger
                var messageLogger = Logger(label: logger.label + ".message")
                messageLogger[metadataKey: "message"] = .string(rawMessage.messageID)
                // TODO: Add trace context to metadata

                // Wrap message
                var message = SubscriberMessage(
                    id: rawMessage.messageID,
                    published: rawMessage.publishTime.date,
                    data: rawMessage.data,
                    attributes: rawMessage.attributes,
                    logger: messageLogger
                )

                // Handle message
                messageLogger.debug("Handling message")

                do {
                    try Task.checkCancellation()
                    try await handler.handle(message: &message)
                } catch {
                    if !(error is CancellationError) {
                        messageLogger.error("Failed to handle message: \(error)")
                    }

                    do {
                        try await unacknowledge(id: receivedMessage.ackID, subscription: subscription)
                        messageLogger.debug("Unacknowledged message")
                    } catch {
                        messageLogger.error("Failed to unacknowledge message: \(error)")
                    }
                    return
                }

                do {
                    try await acknowledge(id: receivedMessage.ackID, subscription: subscription)
                    messageLogger.debug("Acknowledged message")
                } catch {
                    messageLogger.error("Failed to acknowledge message: \(error)")
                    // Should we nack the message?
                }
            }
        }
        for task in tasks {
            _ = try await task.value
        }
    }
}
