import Foundation
import Logging

public protocol SubscriptionHandler {

    var logger: Logger { get }

    func handle(message: SubscriberMessage) async throws
}

private var defaultLoggers = [String: Logger]()

extension SubscriptionHandler {

    public var logger: Logger {
        let name = "handlers." + String(describing: self)
        if let logger = defaultLoggers[name] {
            return logger
        }
        let logger = Logger(label: name)
        defaultLoggers[name] = logger
        return logger
    }
}
