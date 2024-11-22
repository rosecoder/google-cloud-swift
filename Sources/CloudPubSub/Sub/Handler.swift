import Foundation
import Logging

public typealias _Handler = Handler

public protocol Handler: Sendable {

    associatedtype Message: _Message
    typealias Incoming = Message.Incoming
    typealias Context = HandlerContext

    var subscription: Subscription<Message> { get }

    func handle(message: Incoming, context: Context) async throws
}
