import Foundation
import SwiftProtobuf
import Logging

public struct SubscriberMessage: Message {

    public let id: String
    public let published: Date

    public let data: Data
    public let attributes: [String: String]

    public var logger: Logger

    init(id: String, published: Date, data: Data, attributes: [String: String], logger: Logger) {
        self.id = id
        self.published = published
        self.data = data
        self.attributes = attributes
        self.logger = logger
    }

    public func decode<Element: SwiftProtobuf.Message>(_ elementType: Element.Type) throws -> Element {
        try elementType.init(serializedData: data)
    }
}
