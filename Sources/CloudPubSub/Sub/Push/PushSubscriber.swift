import Foundation
import GRPCCore
import NIO
import NIOHTTP1
import Logging
import Tracing
import CloudCore
import RetryableTask
import ServiceLifecycle
import Synchronization

public final class PushSubscriber: Service {

    let logger = Logger(label: "pubsub.subscriber")

    public enum ConfigurationError: Error {
        case missingProjectID
    }

    public let projectID: String

    public convenience init() async throws {
        guard let projectID = await (ServiceContext.current ?? .topLevel).projectID else {
            throw ConfigurationError.missingProjectID
        }
        self.init(projectID: projectID)
    }

    public init(projectID: String) {
        self.projectID = projectID
    }

    // MARK: - Bootstrap

    public func run() async throws {
#if DEBUG
        try await runUsingPull()
        return
#endif

        let port: Int
        if let rawPort = ProcessInfo.processInfo.environment["PORT"], let environmentPort = Int(rawPort) {
            port = environmentPort
        } else {
            port = 8080
        }

        let bootstrap = ServerBootstrap(group: .singletonMultiThreadedEventLoopGroup)
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

        let channel = try await bootstrap.bind(host: "0.0.0.0", port: port).get()

        await withGracefulShutdownHandler {
            // nothing to do here
        } onGracefulShutdown: {
            Task {
                try await channel.close()
            }
        }

        try await channel.closeFuture.get()
    }

#if DEBUG
    private let pubSubService = try! PubSubService()
    private let pullRunTasks = Mutex<[Task<Void, Error>]>([])

    private func runUsingPull() async throws {
        logger.info("Using pull subscriber instead of push. Push is not supported during local development.")

        let tasks = pullRunTasks.withLock { $0 }

        try await withGracefulShutdownHandler {
            try await pubSubService.run()
        } onGracefulShutdown: {
            tasks.forEach { $0.cancel() }
        }

        for task in tasks {
            try? await task.value
        }
    }
#endif

    // MARK: - Subscribe

    private let handlings = Mutex<[String: @Sendable (Incoming) async -> Response]>([:])

    public func register<Handler: _Handler>(handler: Handler) {
#if DEBUG
        let pullTask = Task {
            let subscriber = try await PullSubscriber(handler: handler, pubSubService: pubSubService)
            try await subscriber.run()
        }
        pullRunTasks.withLock {
            $0.append(pullTask)
        }
        return
#endif

        let handleClosure: @Sendable (Incoming) async -> Response = {
            await self.handle(incoming: $0, handler: handler)
        }
        handlings.withLock {
            $0[handler.subscription.id(projectID: projectID)] = handleClosure
        }

        logger.debug("Subscribed to \(handler.subscription.name)")
    }

    @Sendable private func handle(incoming: Incoming) async -> Response {
        guard let handling = handlings.withLock({ $0[incoming.subscription] }) else {
            logger.error("Handler for subscription could not be found: \(incoming.subscription)")
            return .notFound
        }
        return await handling(incoming)
    }

    private struct SubscriptionNotFoundError: Error {

        let name: String
    }

    private func handle<Handler: _Handler>(incoming: Incoming, handler: Handler) async -> Response {
        await withSpan(handler.subscription.name, ofKind: .consumer) { span in
            span.attributes["message"] = incoming.message.id

            var logger = logger
            logger[metadataKey: "subscription"] = .string(handler.subscription.name)
            logger[metadataKey: "message"] = .string(incoming.message.id)
            logger.debug("Handling incoming message. Decoding...")

            let rawMessage = incoming.message
            let message: Handler.Message.Incoming
            do {
                message = try .init(
                    id: rawMessage.id,
                    published: rawMessage.published,
                    data: rawMessage.data,
                    attributes: rawMessage.attributes,
                    logger: &logger,
                    span: span
                )
                try Task.checkCancellation()
            } catch {
                handleFailure(error: error, logger: logger, span: span)
                return .failure
            }

            span.addEvent("message-decoded")
            logger.debug("Handling incoming message. Running handler...")

            let context = HandlerContext(logger: logger, span: span)
            do {
                try await handler.handle(message: message, context: context)
                logger = context.logger
            } catch {
                logger = context.logger
                handleFailure(error: error, logger: logger, span: span)
                return .failure
            }

            logger.debug("Handling successful.")
            span.setStatus(SpanStatus(code: .ok))

            return .success
        }
    }

    private func handleFailure(error: Error, logger: Logger, span: Span) {
        if !(error is CancellationError) {
            logger.error("\(error)")
        } else {
            logger.debug("Handling cancelled.")
        }
        span.recordError(error)
    }
}
