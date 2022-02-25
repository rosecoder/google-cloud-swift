import Foundation
import SwiftProtobuf

public struct PublisherMessage: Message {

    public var data: Data
    public var attributes: [String: String]

    public init(data: Data, attributes: [String: String] = [:]) {
        self.data = data
        self.attributes = attributes
    }

    public init<Element: SwiftProtobuf.Message>(data element: Element, attributes: [String: String] = [:]) throws {
        let data = try element.serializedData()
        self.init(data: data, attributes: attributes)
    }
}
