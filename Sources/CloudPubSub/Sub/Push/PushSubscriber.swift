import Foundation
import GRPC
import NIO
import NIOHTTP1
import Logging
import CloudCore
import CloudTrace
import RetryableTask

public final class PushSubscriber: Subscriber, Dependency {

    static let logger = Logger(label: "pubsub.subscriber")

    // MARK: - Bootstrap

    private static var channel: Channel?

#if DEBUG
    public static var isDebugUsingPull = true
#endif

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        if isDebugUsingPull {
            logger.info("Using pull subscriber instead of push. Push is not supported during local development.")
            try await PullSubscriber.bootstrap(eventLoopGroup: eventLoopGroup)
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
                    channel.pipeline.addHandler(HTTPHandler(handle: self.handle))
                }
            }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)

        channel = try await bootstrap.bind(host: "0.0.0.0", port: port).get()
    }

    // MARK: - Termination

    public static func shutdown() async throws {
#if DEBUG
        if isDebugUsingPull {
            try await PullSubscriber.shutdown()
            return
        }
#endif

        logger.debug("Shutting down subscriptions...")

        try await channel?.close()
        try await PubSub.shutdown()
    }

    // MARK: - Subscribe

    private static var handlings = [String: (Incoming, inout Context) async -> Response]()

    public static func register<Handler>(handler handlerType: Handler.Type) async throws
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
#if DEBUG
        if isDebugUsingPull {
            try await PullSubscriber.startPull(handler: handlerType)
            return
        }
#endif

        handlings[handlerType.subscription.id] = {
            await self.handle(incoming: $0, handlerType: handlerType, context: &$1)
        }

        logger.debug("Subscribed to \(handlerType.subscription.name)")
    }

    private static func handle(incoming: Incoming, trace: Trace?) async -> Response {
        var context = messageContext(subscriptionName: incoming.subscription, rawMessage: incoming.message, trace: trace)

        guard let handling = handlings[incoming.subscription] else {
            context.logger.error("Handler for subscription could not be found: \(incoming.subscription)")
            context.trace?.end(statusCode: .notFound)
            return .notFound
        }
        return await handling(incoming, &context)
    }

    private static func handle<Handler>(incoming: Incoming, handlerType: Handler.Type, context: inout Context) async -> Response
    where Handler: _Handler,
          Handler.Message.Incoming: IncomingMessage
    {
        let rawMessage = incoming.message

        func handleHandler(error: Error) {
            if !(error is CancellationError) {
                context.logger.error("\(error)")
                context.trace?.end(error: error)
            } else {
                context.trace?.end(statusCode: .cancelled)
            }
        }

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
            handleHandler(error: error)
            return .failure
        }

        var handler = handlerType.init(context: context, message: message)
        do {
            try await handler.handle()
            context = handler.context
        } catch {
            context = handler.context
            handleHandler(error: error)
            return .failure
        }

        context.trace?.end(statusCode: .ok)

        return .success
    }
}
