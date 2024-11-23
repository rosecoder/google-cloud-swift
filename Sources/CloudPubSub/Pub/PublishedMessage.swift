import Foundation

public struct PublishedMessage: Sendable {

    public let id: String

    package init(id: String) {
        self.id = id
    }
}
