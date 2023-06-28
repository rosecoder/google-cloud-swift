import Logging

public protocol Context {

    var logger: Logger { get set }
    var trace: Trace? { get set }
}
