import Foundation
import SwiftProtobuf
import GCPTrace

public struct ProtobufMessage<Element: SwiftProtobuf.Message>: Message {

    public typealias Incoming = IncomingProtobufMessage<Element>
    public typealias Outgoing = OutgoingProtobufMessage<Element>
}

// MARK: - Outgoing

public struct OutgoingProtobufMessage<Element: SwiftProtobuf.Message>: OutgoingMessage {

    public var data: Data
    public var attributes: [String: String]

    public init(body: Element, attributes: [String: String] = [:]) throws {
        self.data = try body.serializedData()
        self.attributes = attributes
    }
}

extension Publisher {

    @discardableResult
    public static func publish<Element>(
        to topic: Topic<ProtobufMessage<Element>>,
        body: Element,
        attributes: [String: String] = [:],
        context: Context
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [try .init(body: body, attributes: attributes)], context: context))[0]
    }
}

// MARK: - Incoming

public struct IncomingProtobufMessage<Element: SwiftProtobuf.Message>: IncomingMessage {

    public var id: String
    public var published: Date
    public var attributes: [String: String]

    public var body: Element

    public init(id: String, published: Date, data: Data, attributes: [String: String]) throws {
        self.body = try Element.init(serializedData: data)
        self.id = id
        self.published = published
        self.attributes = attributes
    }
}

#if DEBUG
extension IncomingProtobufMessage {

    public init(
        element: Element,
        attributes: [String: String] = [:]
    ) throws {
        try self.init(data: try element.serializedData(), attributes: attributes)
    }
}
#endif