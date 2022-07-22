import Foundation
import GCPTrace
import Logging

public protocol Handler {

    var context: Context { get }
    var message: SubscriberMessage { get }

    init(context: Context, message: SubscriberMessage)

    func handle() async throws
}

struct HandlerContext: Context {

    var logger: Logger
    var trace: Trace?
}
