import Foundation
import GRPC
import NIO
import OAuth2
import Logging
import GCPCore
import SwiftProtobuf
import GCPTrace

public final class Publisher: Dependency {

    private static var _client: Google_Pubsub_V1_PublisherAsyncClient?
    private static let logger = Logger(label: "pubsub.publisher")

    private static var client: Google_Pubsub_V1_PublisherAsyncClient {
        get {
            guard let _client = _client else {
                fatalError("Must call Publisher.bootstrap(eventLoopGroup:) first")
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

    public static func bootstrap(eventLoopGroup: EventLoopGroup) {

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

    // MARK: - Publish

    @discardableResult
    public static func publish(to topic: Topic, messages: [PublisherMessage], context: Context) async throws -> [PublishedMessage] {
        try await client.ensureAuthentication(authorization: &authorization, context: context, traceContext: "pubsub")

#if DEBUG
        try await topic.createIfNeeded(creation: client.createTopic)
#endif

        let response: Google_Pubsub_V1_PublishResponse = try await context.trace.recordSpan(named: "pubsub-publish", attributes: [
            "pubsub/topic": topic.rawValue,
        ], closure: { span in
            try await client.publish(.with {
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
            .enumerated()
            .map { (index, id) in
                return PublishedMessage(id: id, data: messages[index].data, attributes: messages[index].attributes)
            }
    }

    @discardableResult
    public static func publish(to topic: Topic, message: PublisherMessage, context: Context) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [message], context: context))[0]
    }

    @discardableResult
    public static func publish(to topic: Topic, data: Data, attributes: [String: String] = [:], context: Context) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [PublisherMessage(data: data, attributes: attributes)], context: context))[0]
    }

    @discardableResult
    public static func publish<Element: SwiftProtobuf.Message>(to topic: Topic, data element: Element, attributes: [String: String] = [:], context: Context) async throws -> PublishedMessage {
        let message = try PublisherMessage(data: element, attributes: attributes)
        return (try await publish(to: topic, messages: [message], context: context))[0]
    }
}
