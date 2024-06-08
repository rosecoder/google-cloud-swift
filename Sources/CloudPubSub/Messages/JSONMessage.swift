import Foundation
import CloudTrace

public struct JSONMessage<Element: Codable>: Message {

    public typealias Incoming = IncomingJSONMessage<Element>
    public typealias Outgoing = OutgoingJSONMessage<Element>
}

// MARK: - Outgoing

public struct OutgoingJSONMessage<Element: Encodable>: OutgoingMessage {

    public var data: Data
    public var attributes: [String: String]

    public init(body: Element, attributes: [String: String] = [:]) throws {
        self.data = try JSONEncoder().encode(body)
        self.attributes = attributes
    }
}

extension Publisher {

    @discardableResult
    public static func publish<Element>(
        to topic: Topic<JSONMessage<Element>>,
        body: Element,
        attributes: [String: String] = [:],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, bodies: [body], attributes: attributes, context: context, file: file, function: function, line: line))[0]
    }

    @discardableResult
    public static func publish<Element>(
        to topic: Topic<JSONMessage<Element>>,
        bodies: [Element],
        attributes: [String: String] = [:],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [PublishedMessage] {
        let messages = try bodies.map { try JSONMessage.Outgoing(body: $0, attributes: attributes) }
        return try await publish(to: topic, messages: messages, context: context, file: file, function: function, line: line)
    }
}

// MARK: - Incoming

public struct IncomingJSONMessage<Element: Decodable>: IncomingMessage {

    public let id: String
    public let published: Date
    public let attributes: [String: String]

    public let body: Element

    public init(id: String, published: Date, data: Data, attributes: [String: String], context: inout Context) throws {
        self.body = try JSONDecoder().decode(Element.self, from: data)
        self.id = id
        self.published = published
        self.attributes = attributes
    }
}

#if DEBUG
extension IncomingJSONMessage where Element: Encodable {

    public init(
        body: Element,
        attributes: [String: String] = [:]
    ) throws {
        try self.init(data: try JSONEncoder().encode(body), attributes: attributes)
    }
}
#endif
