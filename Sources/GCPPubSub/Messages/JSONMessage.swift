import Foundation
import GCPTrace

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
        context: Context
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [try .init(body: body, attributes: attributes)], context: context))[0]
    }
}

// MARK: - Incoming

public struct IncomingJSONMessage<Element: Decodable>: IncomingMessage {

    public var id: String
    public var published: Date
    public var attributes: [String: String]

    public var body: Element

    public init(id: String, published: Date, data: Data, attributes: [String: String]) throws {
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