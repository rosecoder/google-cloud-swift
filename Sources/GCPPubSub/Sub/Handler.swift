import Foundation
import GCPTrace
import Logging

public protocol Handler {

    associatedtype Message: GCPPubSub.Message

    static var subscription: Subscription<Message> { get }

    var context: Context { get }
    var message: Message.Incoming { get }

    init(context: Context, message: Message.Incoming)

    mutating func handle() async throws
}

struct HandlerContext: Context {

    var logger: Logger
    var trace: Trace?
}
