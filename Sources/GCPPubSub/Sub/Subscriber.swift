import Foundation
import GRPC
import NIO
import Logging
import GCPCore
import GCPTrace

public final class Subscriber: Dependency {

    private static var _client: Google_Pubsub_V1_SubscriberAsyncClient?
    private static let logger = Logger(label: "pubsub.subscriber")

    private static var client: Google_Pubsub_V1_SubscriberAsyncClient {
        get {
            guard let _client = _client else {
                fatalError("Must call Subscriber.bootstrap(eventLoopGroup:) first")
            }

            return _client
        }
        set {
            _client = newValue
        }
    }

    // MARK: - Bootstrap

    private static var authorization = Authorization(scopes: [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/pubsub",
    ])

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

            self._client = .init(channel: channel)
        }
    }

    // MARK: - Subscribe

    private static var runningPullTasks = [Subscription: Task<Void, Error>]()

    public static func startPull(subscription: Subscription, handler: SubscriptionHandler) async throws {
#if DEBUG
        try await client.ensureAuthentication(authorization: &authorization)
        try await subscription.createIfNeeded(creation: client.createSubscription)
#endif

        continuesPull(subscription: subscription, handler: handler)

        logger.debug("Subscribed to \(subscription.name)")
    }

    private static func continuesPull(subscription: Subscription, handler: SubscriptionHandler) {
        runningPullTasks[subscription] = Task {
            while !Task.isCancelled {
                do {
                    try await singlePull(subscription: subscription, handler: handler)
                } catch {
                    let delay: UInt64
                    switch (error as? GRPCStatus)?.code ?? .unknown {
                    case .unavailable, .deadlineExceeded:
                        logger.debug("Pull failed with short retry error code for \(subscription.name): \(error)")
                        delay = 50_000_000 // 50 ms
                    default:
                        logger.warning("Pull failed for \(subscription.name): \(error)")
                        delay = 1_000_000_000 // 1 sec
                    }

                    try await Task.sleep(nanoseconds: delay)
                    self.continuesPull(subscription: subscription, handler: handler)
                }
            }
        }
    }

    // MARK: - Shutdown

    public static func shutdown() async throws {
        logger.info("Shutting down subscriptions...")

        runningPullTasks.values.forEach { $0.cancel() }
        for task in runningPullTasks.values {
            _ = await task.result
        }
    }

    // MARK: - Acknowledge

    private static func acknowledge(id: String, subscription: Subscription) async throws {
        try await client.ensureAuthentication(authorization: &authorization)

        _ = try await client.acknowledge(.with {
            $0.subscription = subscription.rawValue
            $0.ackIds = [id]
        })
    }

    private static func unacknowledge(id: String, subscription: Subscription) async throws {
        try await client.ensureAuthentication(authorization: &authorization)

        _ = try await client.modifyAckDeadline(.with {
            $0.subscription = subscription.rawValue
            $0.ackIds = [id]
            $0.ackDeadlineSeconds = 0
        })
    }

    // MARK: - Pull

    private static func singlePull(subscription: Subscription, handler: SubscriptionHandler) async throws {
        try await client.ensureAuthentication(authorization: &authorization)

        let response = try await client.pull(.with {
            $0.subscription = subscription.rawValue
            $0.maxMessages = 1_000
        }, callOptions: .init(
            customMetadata: client.defaultCallOptions.customMetadata,
            timeLimit: .deadline(.distantFuture)
        ))
        guard !response.receivedMessages.isEmpty else {
            return
        }

        logger.debug("Received \(response.receivedMessages.count) messages")

        let tasks: [Task<Void, Error>] = response.receivedMessages.map { receivedMessage in
            Task {
                let rawMessage = receivedMessage.message

                // Note: Mutable non-reference properties (e.g. logger and trace) must be defined
                // and only used on the message struct. Otherwise we will miss out on extra metadata.
                var message = SubscriberMessage(
                    id: rawMessage.messageID,
                    published: rawMessage.publishTime.date,
                    data: rawMessage.data,
                    attributes: rawMessage.attributes,
                    logger: {
                        var messageLogger = Logger(label: logger.label + ".message")
                        messageLogger[metadataKey: "pubsub.message"] = .string(rawMessage.messageID)
                        // TODO: Add trace context to metadata
                        return messageLogger
                    }(),
                    trace: Trace(named: subscription.name, attributes: [
                        "message": rawMessage.messageID,
                    ])
                )

                // Handle message
                message.logger.debug("Handling message")

                do {
                    try Task.checkCancellation()
                    try await handler.handle(message: &message)
                } catch {
                    if !(error is CancellationError) {
                        message.logger.error("Failed to handle message: \(error)")
                    }

                    var unacknowledgeSpan = message.trace.span(named: "pubsub-unacknowledge")
                    do {
                        try await unacknowledge(id: receivedMessage.ackID, subscription: subscription)
                        unacknowledgeSpan.end(statusCode: .ok)
                        message.logger.debug("Unacknowledged message")
                    } catch {
                        unacknowledgeSpan.end(error: error)
                        message.logger.error("Failed to unacknowledge message: \(error)")
                    }
                    message.trace.end(error: error)
                    return
                }


                var acknowledgeSpan = message.trace.span(named: "pubsub-acknowledge")
                do {
                    try await acknowledge(id: receivedMessage.ackID, subscription: subscription)
                    acknowledgeSpan.end(statusCode: .ok)
                    message.logger.debug("Acknowledged message")
                } catch {
                    acknowledgeSpan.end(error: error)
                    message.logger.error("Failed to acknowledge message: \(error)")
                    // TODO: Add retry
                    // TODO: Should we nack the message?
                }

                message.trace.end(statusCode: .ok)
            }
        }
        for task in tasks {
            _ = try await task.value
        }
    }
}
