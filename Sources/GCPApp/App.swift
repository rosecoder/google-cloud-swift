import Foundation
import Logging
import NIO
import GCPCore
import GCPLogging

public protocol App {

    var eventLoopGroup: EventLoopGroup { get }

    /// Logger to be used for app during bootstrap and shutdown.
    ///
    /// Default implementation uses a logger with the label `"main"`.
    var logger: Logger { get }

    /// Log level to be used when bootstrapping the logging system.
    ///
    /// Default implementation uses `.debug` for debug builds and `.info` for release builds, unless the `LOG_LEVEL`-environment variable is present.
    ///
    /// The `LOG_LEVEL`-environment variable can have the following values (not case sensative):
    /// - trace
    /// - debug
    /// - info
    /// - notice
    /// - warning
    /// - error
    /// - critical
    var logLevel: Logger.Level { get }

    /// All dependencies to bootstrap on main.
    ///
    /// Bootstrapping is run one at a time in the order given.
    var dependencies: [DependencyOptions] { get }

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

    public var logLevel: Logger.Level {
        if
            let raw = ProcessInfo.processInfo.environment["LOG_LEVEL"],
            let level = Logger.Level(rawValue: raw.lowercased())
        {
            return level
        }
#if DEBUG
        return .debug
#else
        return .info
#endif
    }

    public var dependencies: [Dependency.Type] { [] }

    public func shutdown() async throws {}
}
