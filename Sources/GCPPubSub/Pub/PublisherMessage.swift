import Foundation

public struct PublisherMessage: Message {

    public var data: Data
    public var attributes: [String: String]

    public init(data: Data, attributes: [String: String] = [:]) {
        self.data = data
        self.attributes = attributes
    }

    public init<Element: Encodable>(data element: Element, attributes: [String: String] = [:]) throws {
        let data = try JSONEncoder().encode(element)
        self.init(data: data, attributes: attributes)
    }
}
