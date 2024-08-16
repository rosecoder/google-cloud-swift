import Logging

public protocol Context: Sendable {

    var logger: Logger { get set }
    var trace: Trace? { get set }
}
