import Foundation
import GRPC
import NIO
import NIOHTTP1
import Logging
import CloudCore
import CloudTrace
import RetryableTask

public actor PushSubscriber: Subscriber, Dependency {

    public static let shared = PushSubscriber()

    static let logger = Logger(label: "pubsub.subscriber")

    // MARK: - Bootstrap

    private var channel: Channel?

#if DEBUG
    public static nonisolated(unsafe) var isDebugUsingPull = true
#endif

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        if Self.isDebugUsingPull {
            Self.logger.info("Using pull subscriber instead of push. Push is not supported during local development.")
            try await PullSubscriber.shared.bootstrap(eventLoopGroup: eventLoopGroup)
            return
        }
#endif

        let port: Int
        if let rawPort = ProcessInfo.processInfo.environment["PORT"], let environmentPort = Int(rawPort) {
            port = environmentPort
        } else {
            port = 8080
        }

        let bootstrap = ServerBootstrap(group: eventLoopGroup)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().flatMap { _ in
                    channel.pipeline.addHandler(HTTPHandler(handle: Self.handle))
                }
            }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)

        channel = try await bootstrap.bind(host: "0.0.0.0", port: port).get()
    }

    // MARK: - Termination

    public func shutdown() async throws {
#if DEBUG
        if Self.isDebugUsingPull {
            try await PullSubscriber.shared.shutdown()
            return
        }
#endif

        Self.logger.debug("Shutting down subscriptions...")

        try await channel?.close()
        try await PubSub.shared.shutdown()
    }

    // MARK: - Subscribe

    private static var handlings = [String: (Incoming, inout Context) async -> Response]()

    public static func register<Handler>(handler: Handler) async throws
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
#if DEBUG
        if isDebugUsingPull {
            try await PullSubscriber.startPull(handler: handler)
            return
        }
#endif

        if await shared.channel == nil {
            try await shared.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
        }

        handlings[handler.subscription.id] = {
            await self.handle(incoming: $0, handler: handler, context: &$1)
        }

        logger.debug("Subscribed to \(handler.subscription.name)")
    }

    @Sendable private static func handle(incoming: Incoming, trace: Trace?) async -> Response {
        var context = messageContext(subscriptionName: incoming.subscription, rawMessage: incoming.message, trace: trace)

        guard let handling = handlings[incoming.subscription] else {
            context.logger.error("Handler for subscription could not be found: \(incoming.subscription)")
            context.trace?.end(statusCode: .notFound)
            return .notFound
        }
        return await handling(incoming, &context)
    }

    private static func handle<Handler>(incoming: Incoming, handler: Handler, context: inout Context) async -> Response
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        context.logger[metadataKey: "subscription"] = .string(incoming.subscription)
        context.logger[metadataKey: "message"] = .string(incoming.message.id)
        context.logger.debug("Handling incoming message. Decoding...")

        let rawMessage = incoming.message
        let message: Handler.Message.Incoming
        do {
            message = try .init(
                id: rawMessage.id,
                published: rawMessage.published,
                data: rawMessage.data,
                attributes: rawMessage.attributes,
                context: &context
            )
            try Task.checkCancellation()
        } catch {
            handleFailure(error: error, context: &context)
            return .failure
        }

        context.logger.debug("Handling incoming message. Running handler...")

        do {
            try await handler.handle(message: message, context: context)
        } catch {
            handleFailure(error: error, context: &context)
            return .failure
        }

        context.logger.debug("Handling successful.")
        context.trace?.end(statusCode: .ok)

        return .success
    }

    private static func handleFailure(error: Error, context: inout Context) {
        if !(error is CancellationError) {
            context.logger.error("\(error)")
            context.trace?.end(error: error)
        } else {
            context.logger.debug("Handling cancelled.")
            context.trace?.end(statusCode: .cancelled)
        }
    }
}
