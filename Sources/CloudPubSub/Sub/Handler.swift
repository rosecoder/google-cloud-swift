import Foundation
import Logging

public typealias _Handler = Handler

public protocol Handler: Sendable {

    associatedtype Message: _Message
    typealias Incoming = Message.Incoming

    var subscription: Subscription<Message> { get }

    func handle(message: Incoming) async throws
}
