import Foundation
import Logging
import NIO
import GCPCore
import GCPLogging

public typealias Dependency = GCPCore.Dependency

public protocol App {

    var eventLoopGroup: EventLoopGroup { get }

    /// Logger to be used for app during bootstrap and shutdown.
    ///
    /// Default implementation uses a logger with the label `"main"`.
    var logger: Logger { get }

    /// Log level to be used when bootstrapping the logging system.
    ///
    /// Default implementation uses `.debug` for debug builds and `.info` for release builds.
    var logLevel: Logger.Level { get }

    /// All dependency types to bootstrap on main.
    ///
    /// Bootstrapping is run one at a time in the order given.
    var dependencies: [Dependency.Type] { get }

    /// Implement this to do any extra work needed before termination.
    ///
    /// Default implementation isn't doing anything.
    func shutdown() async throws
}

// MARK: - Default implementations

private let defaultEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
private let defaultLogger = Logger(label: "main")

extension App {

    public var eventLoopGroup: EventLoopGroup { defaultEventLoopGroup }

    public var logger: Logger { defaultLogger }
    #if DEBUG
    public var logLevel: Logger.Level { .debug }
    #else
    public var logLevel: Logger.Level { .info }
    #endif

    public var dependencies: [Dependency.Type] { [] }

    public func shutdown() async throws {}
}
