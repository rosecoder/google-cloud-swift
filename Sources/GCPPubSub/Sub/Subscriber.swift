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

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        try await PubSub.bootstrap(eventLoopGroup: eventLoopGroup)

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

    // MARK: - Termination

    public static func shutdown() async throws {
        logger.debug("Shutting down subscriptions...")

        runningPullTasks.values.forEach { $0.cancel() }
        for task in runningPullTasks.values {
            _ = await task.result
        }

        try await PubSub.shutdown()
    }

    // MARK: - Subscribe

    private typealias SubscriptionHash = Int
    private static var runningPullTasks = [SubscriptionHash: Task<Void, Error>]()

    public static func startPull<Handler>(handler handlerType: Handler.Type) async throws
    where Handler: GCPPubSub.Handler,
          Handler.Message.Incoming: IncomingMessage
    {
#if DEBUG
        try await client.ensureAuthentication(authorization: PubSub.authorization)
        try await handlerType.subscription.createIfNeeded(creation: client.createSubscription)
#endif

        continuesPull(handlerType: handlerType)

        logger.debug("Subscribed to \(handlerType.subscription.name)")
    }

    private static func continuesPull<Handler>(handlerType: Handler.Type, retryCount: UInt64 = 0)
    where Handler: GCPPubSub.Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        runningPullTasks[handlerType.subscription.name.hashValue] = Task {
            while !Task.isCancelled {
                do {
                    try await singlePull(handlerType: handlerType)
                } catch {
                    try Task.checkCancellation()

                    var delay: UInt64
                    let log: (@autoclosure () -> Logger.Message, @autoclosure () -> Logger.Metadata?, String, String, UInt) -> ()
                    switch error as? ChannelError {
                    case .ioOnClosedChannel:
                        log = logger.debug
                        delay = 50_000_000 // 50 ms
                    default:
                        switch (error as? GRPCStatus)?.code ?? .unknown {
                        case .unavailable:
                            log = logger.debug
                            delay = 200_000_000 // 200 ms
                        case .deadlineExceeded:
                            log = logger.debug
                            delay = 50_000_000 // 50 ms
                        default:
                            log = logger.warning
                            delay = 1_000_000_000 // 1 sec
                        }
                    }
                    delay *= (retryCount + 1)

                    log("Pull failed for \(handlerType.subscription.name) (retry in \(delay / 1_000_000)ms): \(error)", nil, #file, #function, #line)

                    try await Task.sleep(nanoseconds: delay)

                    try Task.checkCancellation()

                    self.continuesPull(handlerType: handlerType, retryCount: retryCount + 1)
                    break
                }
            }
        }
    }

    // MARK: - Acknowledge

    private static func acknowledge(id: String, subscriptionName: String, context: Context) async throws {
        try await client.ensureAuthentication(authorization: PubSub.authorization, context: context, traceContext: "pubsub")

        try await context.trace.recordSpan(named: "pubsub-acknowledge", kind: .client) { span in
            _ = try await client.acknowledge(.with {
                $0.subscription = subscriptionName
                $0.ackIds = [id]
            })
        }
    }

    private static func unacknowledge(id: String, subscriptionName: String, context: Context) async throws {
        try await client.ensureAuthentication(authorization: PubSub.authorization, context: context, traceContext: "pubsub")

        try await context.trace.recordSpan(named: "pubsub-unacknowledge", kind: .client) { span in
            _ = try await client.modifyAckDeadline(.with {
                $0.subscription = subscriptionName
                $0.ackIds = [id]
                $0.ackDeadlineSeconds = 0
            })
        }
    }

    // MARK: - Pull

    private static func singlePull<Handler>(handlerType: Handler.Type) async throws
    where Handler: GCPPubSub.Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        try await client.ensureAuthentication(authorization: PubSub.authorization)

        let response = try await client.pull(.with {
            $0.subscription = handlerType.subscription.rawValue
            $0.maxMessages = 1_000
        }, callOptions: .init(
            customMetadata: client.defaultCallOptions.customMetadata,
            timeLimit: .deadline(.distantFuture)
        ))
        guard !response.receivedMessages.isEmpty else {
            return
        }

        let tasks: [Task<Void, Error>] = response.receivedMessages.map { receivedMessage in
            Task {
                let rawMessage = receivedMessage.message

                var context: Context = HandlerContext(
                    logger: {
                        var messageLogger = Logger(label: logger.label + ".message")
                        messageLogger[metadataKey: "pubsub.message"] = .string(rawMessage.messageID)
                        return messageLogger
                    }(),
                    trace: Trace(
                        named: handlerType.subscription.name,
                        kind: .consumer,
                        attributes: [
                            "message": rawMessage.messageID,
                        ]
                    )
                )
                if let trace = context.trace {
                    context.logger.addMetadata(for: trace)
                }

                // Link to parent trace if included in message
                if
                    let rawSourceTraceID = rawMessage.attributes["__traceID"],
                    let rawSourceSpanID = rawMessage.attributes["__spanID"],
                    let traceID = Trace.Identifier(stringValue: rawSourceTraceID),
                    let spanID = Span.Identifier(stringValue: rawSourceSpanID)
                {
                    context.trace?.rootSpan?.links.append(.init(
                        trace: Trace(id: traceID, spanID: spanID),
                        kind: .parent
                    ))
                }

                // Handle message
                func handleHandler(error: Error) async throws {
                    if !(error is CancellationError) {
                        context.logger.error("Failed to handle message: \(error)")
                    }

                    do {
                        try await unacknowledge(id: receivedMessage.ackID, subscriptionName: handlerType.subscription.rawValue, context: context)
                    } catch {
                        context.logger.error("Failed to unacknowledge message: \(error)")
                    }
                    context.trace?.end(error: error)
                }

                let message: Handler.Message.Incoming
                do {
                    message = try .init(
                        id: rawMessage.messageID,
                        published: rawMessage.publishTime.date,
                        data: rawMessage.data,
                        attributes: rawMessage.attributes,
                        context: &context
                    )
                    try Task.checkCancellation()
                } catch {
                    try await handleHandler(error: error)
                    return
                }

                var handler = Handler.init(context: context, message: message)
                do {
                    try await handler.handle()
                    context = handler.context
                } catch {
                    context = handler.context
                    try await handleHandler(error: error)
                    return
                }

                do {
                    try await acknowledge(id: receivedMessage.ackID, subscriptionName: handlerType.subscription.rawValue, context: context)
                } catch {
                    context.logger.error("Failed to acknowledge message: \(error)")
                    // TODO: Add retry
                    // TODO: Should we nack the message?
                }

                context.trace?.end(statusCode: .ok)
            }
        }
        for task in tasks {
            _ = try await task.value
        }
    }
}
