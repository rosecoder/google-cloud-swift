import Foundation
import GCPTrace
import Logging

public protocol Handler {

    associatedtype Message
    associatedtype IncomingMessage

    var context: Context { get }
    var message: IncomingMessage { get }

    init(context: Context, message: IncomingMessage)

    func handle() async throws
}

struct HandlerContext: Context {

    var logger: Logger
    var trace: Trace?
}
