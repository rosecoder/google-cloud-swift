import Foundation
import GRPC
import NIO
import Logging
import CloudCore
import CloudTrace
import RetryableTask

public actor PullSubscriber: Subscriber, Dependency {

    public static var shared = PullSubscriber()

    private var _client: Google_Pubsub_V1_SubscriberAsyncClient?
    static let logger = Logger(label: "pubsub.subscriber")

    private func client(context: Context?) async throws -> Google_Pubsub_V1_SubscriberAsyncClient {
        if _client == nil {
            try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
        }
        var _client = _client!
        try await _client.ensureAuthentication(authorization: PubSub.shared.authorization, context: context, traceContext: "pubsub")
        self._client = _client
        return _client
    }

    // MARK: - Bootstrap

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        try await PubSub.shared.bootstrap(eventLoopGroup: eventLoopGroup)

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

    public func shutdown() async throws {
        Self.logger.debug("Shutting down subscriptions...")

        runningPullTasks.values.forEach { $0.cancel() }
        for task in runningPullTasks.values {
            _ = await task.result
        }

        try await PubSub.shared.shutdown()
    }

    // MARK: - Subscribe

    private typealias SubscriptionHash = Int
    private var runningPullTasks = [SubscriptionHash: Task<Void, Error>]()

    private func runPull(hashValue: SubscriptionHash, operation: @escaping () async throws -> Void) {
        runningPullTasks[hashValue] = Task {
            try await operation()
        }
    }

    public static func startPull<Handler>(handler handlerType: Handler.Type) async throws
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
#if DEBUG
        try await handlerType.subscription.createIfNeeded(creation: try await shared.client(context: nil).createSubscription, logger: logger)
#endif

        continuesPull(handlerType: handlerType)

        logger.debug("Subscribed to \(handlerType.subscription.name)")
    }

    private static func continuesPull<Handler>(handlerType: Handler.Type, retryCount: UInt64 = 0)
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        Task {
            await shared.runPull(hashValue: handlerType.subscription.name.hashValue) {
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
    }

    // MARK: - Acknowledge

    private static func acknowledge(id: String, subscriptionName: String, context: Context) async throws {
        try await withRetryableTask(logger: context.logger) {
            _ = try await shared.client(context: context).acknowledge(.with {
                $0.subscription = subscriptionName
                $0.ackIds = [id]
            })
        }
    }

    private static func unacknowledge(id: String, subscriptionName: String, context: Context) async throws {
        try await withRetryableTask(logger: context.logger) {
            _ = try await shared.client(context: context).modifyAckDeadline(.with {
                $0.subscription = subscriptionName
                $0.ackIds = [id]
                $0.ackDeadlineSeconds = 0
            })
        }
    }

    // MARK: - Pull

    private static func singlePull<Handler>(handlerType: Handler.Type) async throws
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        let response = try await shared.client(context: nil).pull(.with {
            $0.subscription = handlerType.subscription.rawValue
            $0.maxMessages = 1_000
        }, callOptions: .init(
            customMetadata: try await shared.client(context: nil).defaultCallOptions.customMetadata,
            timeLimit: .deadline(.distantFuture)
        ))
        guard !response.receivedMessages.isEmpty else {
            return
        }

        let tasks: [Task<Void, Error>] = response.receivedMessages.map { receivedMessage in
            Task {
                try await handle(receivedMessage: receivedMessage, handlerType: handlerType)
            }
        }
        for task in tasks {
            _ = try await task.value
        }
    }

    private static func handle<Handler>(receivedMessage: Google_Pubsub_V1_ReceivedMessage, handlerType: Handler.Type) async throws
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        let rawMessage = receivedMessage.message

        var context = messageContext(subscriptionName: handlerType.subscription.name, rawMessage: rawMessage, trace: nil)

        func handleHandler(error: Error) async throws {
            if !(error is CancellationError) {
                context.logger.error("\(error)")
                context.trace?.end(error: error)
            } else {
                context.trace?.end(statusCode: .cancelled)
            }

            do {
                try await unacknowledge(id: receivedMessage.ackID, subscriptionName: handlerType.subscription.rawValue, context: context)
            } catch {
                context.logger.error("Failed to unacknowledge message: \(error)")
            }
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

        context.trace?.end(statusCode: .ok)

        do {
            try await acknowledge(id: receivedMessage.ackID, subscriptionName: handlerType.subscription.rawValue, context: context)
        } catch {
            context.logger.critical("Failed to acknowledge message: \(error)")
        }
    }
}
