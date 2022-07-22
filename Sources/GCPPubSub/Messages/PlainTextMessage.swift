import Foundation
import GCPTrace

public struct PlainTextMessage: Message {

    public typealias Incoming = IncomingPlainTextMessage
    public typealias Outgoing = OutgoingPlainTextMessage
}

// MARK: - Outgoing

public struct OutgoingPlainTextMessage: OutgoingMessage {

    public var data: Data
    public var attributes: [String: String]

    struct EncodingError: Error {}

    public init(body: String, attributes: [String: String] = [:]) throws {
        guard let data = body.data(using: .utf8) else {
            throw EncodingError()
        }

        self.data = data
        self.attributes = attributes
    }
}

extension Publisher {

    @discardableResult
    public static func publish(
        to topic: Topic<PlainTextMessage>,
        body: String,
        attributes: [String: String] = [:],
        context: Context
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [try .init(body: body, attributes: attributes)], context: context))[0]
    }
}

// MARK: - Incoming

public struct IncomingPlainTextMessage: IncomingMessage {

    public let id: String
    public let published: Date
    public let attributes: [String: String]

    public let body: String

    struct DecodingError: Error {}

    public init(id: String, published: Date, data: Data, attributes: [String: String]) throws {
        guard let text = String(data: data, encoding: .utf8) else {
            throw DecodingError()
        }

        self.id = id
        self.published = published
        self.attributes = attributes
        self.body = text
    }
}

#if DEBUG
extension IncomingPlainTextMessage {

    public init(
        body: String,
        attributes: [String: String] = [:]
    ) throws {
        try self.init(data: body.data(using: .utf8)!, attributes: attributes)
    }
}
#endif
