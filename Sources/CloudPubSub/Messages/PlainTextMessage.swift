import Foundation
import Logging
import Tracing

public struct PlainTextMessage: Message {

    public typealias Incoming = IncomingPlainTextMessage
    public typealias Outgoing = OutgoingPlainTextMessage
}

extension PlainTextMessage: Sendable {}

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

extension OutgoingPlainTextMessage: Sendable {}

extension Publisher {

    @discardableResult
    public func publish(
        to topic: Topic<PlainTextMessage>,
        body: String,
        attributes: [String: String] = [:],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, bodies: [body], attributes: attributes, file: file, function: function, line: line))[0]
    }
    
    @discardableResult
    public func publish(
        to topic: Topic<PlainTextMessage>,
        bodies: [String],
        attributes: [String: String] = [:],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [PublishedMessage] {
        let messages = try bodies.map { try PlainTextMessage.Outgoing(body: $0, attributes: attributes) }
        return try await publish(to: topic, messages: messages, file: file, function: function, line: line)
    }
}

// MARK: - Incoming

public struct IncomingPlainTextMessage: IncomingMessage {

    public let id: String
    public let published: Date
    public let attributes: [String: String]

    public let body: String

    struct DecodingError: Error {}

    public init(id: String, published: Date, data: Data, attributes: [String: String], logger: inout Logger, span: any Span) throws {
        guard let text = String(data: data, encoding: .utf8) else {
            throw DecodingError()
        }

        self.id = id
        self.published = published
        self.attributes = attributes
        self.body = text
    }
}

extension IncomingPlainTextMessage: Sendable {}

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
