import Foundation
import GRPC
import NIO
import OAuth2
import Logging
import GCPCore
import SwiftProtobuf

public final class Publisher: Dependency {

    private var _client: Google_Pubsub_V1_PublisherAsyncClient
    private let logger = Logger(label: "pubsub.publisher")

    private init(eventLoopGroup: EventLoopGroup) async throws {

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

            let accessToken = try await AccessToken(
                scopes: ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/pubsub"]
            ).generate(didRefresh: { accessToken in
                Self.shared._client.defaultCallOptions.customMetadata.replaceOrAdd(name: "authorization", value: "Bearer \(accessToken)")
            })

            let callOptions = CallOptions(
                customMetadata: ["authorization": "Bearer \(accessToken)"]
            )
            self._client = .init(channel: channel, defaultCallOptions: callOptions)
        }
    }

    // MARK: - Bootstrap

    public private(set) static var shared: Publisher!

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        shared = try await Self.init(eventLoopGroup: eventLoopGroup)
    }

    // MARK: - Publish

    @discardableResult
    public func publish(to topic: Topic, messages: [PublisherMessage]) async throws -> [PublishedMessage] {
#if DEBUG
        try await topic.createIfNeeded(creation: _client.createTopic)
#endif

        let response = try await _client.publish(.with {
            $0.topic = topic.rawValue
            $0.messages = messages.map { message in
                Google_Pubsub_V1_PubsubMessage.with {
                    $0.data = message.data
                    $0.attributes = message.attributes
                }
            }
        })

        return response
            .messageIds
            .enumerated()
            .map { (index, id) in
                logger.debug("Published message", metadata: ["message": .string(id)])
                return PublishedMessage(id: id, data: messages[index].data, attributes: messages[index].attributes)
            }
    }

    @discardableResult
    public func publish(to topic: Topic, message: PublisherMessage) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [message]))[0]
    }

    @discardableResult
    public func publish(to topic: Topic, data: Data, attributes: [String: String] = [:]) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [PublisherMessage(data: data, attributes: attributes)]))[0]
    }

    @discardableResult
    public func publish<Element: SwiftProtobuf.Message>(to topic: Topic, data element: Element, attributes: [String: String] = [:]) async throws -> PublishedMessage {
        let message = try PublisherMessage(data: element, attributes: attributes)
        return (try await publish(to: topic, messages: [message]))[0]
    }
}
