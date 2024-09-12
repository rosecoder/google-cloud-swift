import Foundation
import CloudTrace
import Logging

public typealias _Handler = Handler

public protocol Handler: Sendable {

    associatedtype Message: _Message
    typealias Incoming = Message.Incoming

    var subscription: Subscription<Message> { get }

    func handle(message: Incoming, context: Context) async throws
}

struct HandlerContext: Context {

    var logger: Logger
    var trace: Trace?
}
