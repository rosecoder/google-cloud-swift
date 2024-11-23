import Foundation
import GRPCCore
import NIO
import Logging
import Tracing
import CloudCore
import RetryableTask
import ServiceLifecycle
import GoogleCloudAuth

public final class PullSubscriber<Handler: _Handler>: Service {

    private let logger: Logger

    private let handler: Handler
    private let client: Google_Pubsub_V1_Subscriber_ClientProtocol
    private let pubSubService: PubSubService

    public init(handler: Handler, pubSubService: PubSubService) {
        self.logger = Logger(label: "pubsub.subscriber." + handler.subscription.name)
        self.handler = handler
        self.client = Google_Pubsub_V1_Subscriber_Client(wrapping: pubSubService.grpcClient)
        self.pubSubService = pubSubService
    }

    public func run() async throws {
#if DEBUG
        try await handler.subscription.createIfNeeded(
            subscriberClient: client,
            publisherClient: Publisher(pubSubService: pubSubService).client
        )
#endif

        logger.debug("Subscribed to \(handler.subscription.name)")

        let blockerTask: Task<Void, Never> = Task {
            try? await Task.sleepUntilCancelled()
        }
        pubSubService.registerBlockerForGRPCShutdown(task: blockerTask)

        await cancelWhenGracefulShutdown {
            await self.continuesPull()
        }

        blockerTask.cancel()
    }

    private func continuesPull() async {
        var retryCount: UInt64 = 0
        while !Task.isCancelled {
            do {
                try await singlePull()
                retryCount = 0
            } catch {
                if Task.isCancelled {
                    break
                }

                var delay: UInt64
                let log: (@autoclosure () -> Logger.Message, @autoclosure () -> Logger.Metadata?, String, String, UInt) -> ()
                switch error as? ChannelError {
                case .ioOnClosedChannel:
                    log = logger.debug
                    delay = 50_000_000 // 50 ms
                default:
                    switch (error as? RPCError)?.code ?? .unknown {
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

                log("Pull failed for \(handler.subscription.name) (retry in \(delay / 1_000_000)ms): \(error)", nil, #file, #function, #line)

                try? await Task.sleep(nanoseconds: delay)

                retryCount += 1
            }
        }
    }

    // MARK: - Pull

    private func singlePull() async throws {
        var options = GRPCCore.CallOptions.defaults
        options.timeout = .seconds(3600)

        let response = try await client.pull(.with {
            $0.subscription = handler.subscription.rawValue
            $0.maxMessages = 1_000
        }, options: options)

        guard !response.receivedMessages.isEmpty else {
            return
        }

        await Task.detached { // Run detached so we don't forward the cancellation. Let handling of messages continue.
            await withDiscardingTaskGroup { group in
                for message in response.receivedMessages {
                    group.addTask {
                        await self.handle(message: message)
                    }
                }
            }
        }.value
    }

    private func handle(message: Google_Pubsub_V1_ReceivedMessage) async {
        await withSpan(handler.subscription.id, ofKind: .consumer) { span in
            var logger = self.logger
            span.attributes["message"] = message.message.messageID

            let decodedMessage: Handler.Message.Incoming
            do {
                let rawMessage = message.message
                decodedMessage = try .init(
                    id: rawMessage.messageID,
                    published: rawMessage.publishTime.date,
                    data: rawMessage.data,
                    attributes: rawMessage.attributes,
                    logger: &logger,
                    span: span
                )
                try Task.checkCancellation()
            } catch {
                await handleHandler(error: error, message: message, logger: logger, span: span)
                return
            }
            span.addEvent(SpanEvent(name: "message-decoded"))

            let context = HandlerContext(logger: logger, span: span)
            do {
                try await handler.handle(message: decodedMessage, context: context)
                logger = context.logger
            } catch {
                logger = context.logger
                await handleHandler(error: error, message: message, logger: logger, span: span)
                return
            }
            span.setStatus(SpanStatus(code: .ok))

            do {
                try await acknowledge(id: message.ackID, subscriptionName: handler.subscription.rawValue, logger: logger)
            } catch {
                logger.critical("Failed to acknowledge message: \(error)")
            }
        }
    }

    func handleHandler(error: Error, message: Google_Pubsub_V1_ReceivedMessage, logger: Logger, span: any Span) async {
        if !(error is CancellationError) {
            logger.error("\(error)")
        }
        span.recordError(error)

        do {
            try await unacknowledge(id: message.ackID, subscriptionName: handler.subscription.rawValue, logger: logger)
        } catch {
            logger.error("Failed to unacknowledge message: \(error)")
        }
    }

    // MARK: - Acknowledge

    private func acknowledge(id: String, subscriptionName: String, logger: Logger) async throws {
        try await withRetryableTask(logger: logger) {
            _ = try await client.acknowledge(Google_Pubsub_V1_AcknowledgeRequest.with {
                $0.subscription = subscriptionName
                $0.ackIds = [id]
            })
        }
    }

    private func unacknowledge(id: String, subscriptionName: String, logger: Logger) async throws {
        try await withRetryableTask(logger: logger) {
            _ = try await client.modifyAckDeadline(Google_Pubsub_V1_ModifyAckDeadlineRequest.with {
                $0.subscription = subscriptionName
                $0.ackIds = [id]
                $0.ackDeadlineSeconds = 0
            })
        }
    }
}
