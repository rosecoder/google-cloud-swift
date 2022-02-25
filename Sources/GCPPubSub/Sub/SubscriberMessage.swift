import Foundation
import SwiftProtobuf

public struct SubscriberMessage: Message {

    public let id: String
    public let published: Date

    public let data: Data
    public let attributes: [String: String]

    init(id: String, published: Date, data: Data, attributes: [String: String]) {
        self.id = id
        self.published = published
        self.data = data
        self.attributes = attributes
    }

    public func decode<Element: SwiftProtobuf.Message>(_ elementType: Element.Type) throws -> Element {
        try elementType.init(serializedData: data)
    }
}
