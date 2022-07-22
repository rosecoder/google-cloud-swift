import Foundation
import SwiftProtobuf
import Logging
import GCPTrace

public struct SubscriberMessage: Message, Context {

    public let id: String
    public let published: Date

    public let data: Data
    public let attributes: [String: String]

    public var logger: Logger
    public var trace: Trace?

    init(id: String, published: Date, data: Data, attributes: [String: String], logger: Logger, trace: Trace?) {
        self.id = id
        self.published = published
        self.data = data
        self.attributes = attributes
        self.logger = logger
        self.trace = trace
    }

#if DEBUG
    /// Only for testing. Use this initializer to create a message for testing a handler.
    /// - Parameters:
    ///   - id: Id for the message. Default always "0".
    ///   - published: Date of when message was published. Default to current date. Change this if you want to test handlers with old messages.
    ///   - data: Body data of the message.
    ///   - attributes: Attributes for the message. Default empty dictionary.
    public init(
        id: String = "0",
        published: Date = Date(),
        data: Data,
        attributes: [String: String] = [:]
    ) {
        var logger = Logger(label: "pubsub.subscriber.message")
        logger[metadataKey: "message"] = .string("0")

        self.init(
            id: id,
            published: published,
            data: data,
            attributes: attributes,
            logger: logger,
            trace: Trace(id: .init(), spanID: .init())
        )
    }
#endif
    
    public func decode<Element: SwiftProtobuf.Message>(_ elementType: Element.Type) throws -> Element {
        try elementType.init(serializedData: data)
    }
}
