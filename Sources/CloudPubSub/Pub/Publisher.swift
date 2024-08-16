import Foundation
import GRPC
import NIO
import Logging
import CloudCore
import SwiftProtobuf
import CloudTrace
import RetryableTask

public actor Publisher: Dependency {

    public static var shared = Publisher()

    var _client: Google_Pubsub_V1_PublisherAsyncClient?
    private static let logger = Logger(label: "pubsub.publisher")

#if DEBUG
    /// If `true` (default), publishing messges are preformed on remote, else, if set to `false`, publishing message only encodes the messages, but never actually publishes.
    ///
    /// This property is set to `false`, when `bootstrapForTesting(eventLoopGroup:)` is called.
    ///
    /// Note: This property is only available in DEBUG to avoid unexpected behaviours in production.
    public static var isEnabled = true
#endif

    private func client(context: Context) async throws -> Google_Pubsub_V1_PublisherAsyncClient {
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

#if DEBUG
    /// Bootstraps for testing only by setting `isEnabled` to `false`.
    /// - Parameter eventLoopGroup: NIO event loop group to use. This property is currently never used, but may change in the future.
    public func bootstrapForTesting(eventLoopGroup: EventLoopGroup) async throws {
        Self.isEnabled = false
    }
#endif

    // MARK: - Termination

    public func shutdown() async throws {
        try await PubSub.shared.shutdown()
    }

    // MARK: - Publish

    @discardableResult
    public static func publish<Message>(
        to topic: Topic<Message>,
        messages: [Message.Outgoing],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [PublishedMessage]
    where Message.Outgoing: OutgoingMessage {
        try await withRetryableTask(logger: context.logger, operation: {
            context.logger.debug("Publishing \(messages.count) message(s)...")

#if DEBUG
            guard isEnabled else {
                return messages.map { _ in
                    PublishedMessage(id: "xctest")
                }
            }
#endif

#if DEBUG
            try await topic.createIfNeeded(creation: {
                try await shared.client(context: context).createTopic($0, callOptions: $1)
            })
#endif

            let response: Google_Pubsub_V1_PublishResponse = try await context.trace.recordSpan(named: "pubsub-publish", kind: .producer, attributes: [
                "pubsub/topic": topic.rawValue,
            ], closure: { span in
                try await shared.client(context: context).publish(.with {
                    $0.topic = topic.rawValue
                    $0.messages = messages.map { message in
                        Google_Pubsub_V1_PubsubMessage.with {
                            $0.data = message.data
                            $0.attributes = message.attributes
                            if let trace = context.trace {
                                $0.attributes["__traceID"] = trace.id.stringValue
                                $0.attributes["__spanID"] = (trace.rootSpan?.id ?? trace.spanID).stringValue
                            }
                        }
                    }
                })
            })

            return response
                .messageIds
                .map { PublishedMessage(id: $0) }
        }, file: file, function: function, line: line)
    }

    @discardableResult
    public static func publish<Message>(
        to topic: Topic<Message>,
        message: Message.Outgoing,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> PublishedMessage
    where Message.Outgoing: OutgoingMessage {
        (try await publish(to: topic, messages: [message], context: context))[0]
    }
}
