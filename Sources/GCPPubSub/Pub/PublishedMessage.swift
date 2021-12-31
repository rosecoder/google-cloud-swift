import Foundation

public struct PublishedMessage: Message {

    public let id: String

    public let data: Data
    public let attributes: [String: String]
}
