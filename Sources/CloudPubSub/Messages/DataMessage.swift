import Foundation
import CloudTrace

public struct DataMessage: Message {

    public typealias Incoming = IncomingDataMessage
    public typealias Outgoing = OutgoingDataMessage
}

// MARK: - Outgoing

public struct OutgoingDataMessage: OutgoingMessage {

    public var data: Data
    public var attributes: [String: String]

    public init(body: Data, attributes: [String: String] = [:]) throws {
        self.data = body
        self.attributes = attributes
    }
}

extension Publisher {

    @discardableResult
    public static func publish(
        to topic: Topic<DataMessage>,
        body: Data,
        attributes: [String: String] = [:],
        context: Context
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, bodies: [body], attributes: attributes, context: context))[0]
    }

    @discardableResult
    public static func publish(
        to topic: Topic<DataMessage>,
        bodies: [Data],
        attributes: [String: String] = [:],
        context: Context
    ) async throws -> [PublishedMessage] {
        let messages = try bodies.map { try DataMessage.Outgoing(body: $0, attributes: attributes) }
        return try await publish(to: topic, messages: messages, context: context)
    }
}

// MARK: - Incoming

public struct IncomingDataMessage: IncomingMessage {

    public let id: String
    public let published: Date
    public let attributes: [String: String]

    public let body: Data

    public init(id: String, published: Date, data: Data, attributes: [String: String], context: inout Context) throws {
        self.id = id
        self.published = published
        self.attributes = attributes
        self.body = data
    }
}

#if DEBUG
extension IncomingDataMessage {

    public init(
        body: Data,
        attributes: [String: String] = [:]
    ) throws {
        try self.init(data: body, attributes: attributes)
    }
}
#endif
