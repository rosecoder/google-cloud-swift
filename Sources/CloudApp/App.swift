import Foundation
import Logging
import NIO
import CloudCore
import CloudLogger

public protocol App {

    static var eventLoopGroup: EventLoopGroup { get }

    /// Logger to be used for app during bootstrap and shutdown.
    ///
    /// Default implementation uses a logger with the label `"main"`.
    static var logger: Logger { get }

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
    static var logLevel: Logger.Level { get }

    /// All dependencies to bootstrap on main.
    ///
    /// Bootstrapping is run one at a time in the order given.
    static var dependencies: [DependencyOptions] { get }

    /// Implement this to do any extra work at bootstrap.
    ///
    /// Default implementation isn't doing anything.
    static func bootstrap() async throws -> Void

    /// Implement this to do any extra work needed before termination.
    ///
    /// Default implementation isn't doing anything.
    static func shutdown() async throws
}

// MARK: - Default implementations

private let defaultEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
private let defaultLogger = Logger(label: "main")

extension App {

    public static var eventLoopGroup: EventLoopGroup { defaultEventLoopGroup }

    public static var logger: Logger { defaultLogger }

    public static var logLevel: Logger.Level {
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

    public static var dependencies: [DependencyOptions] { [] }

    public static func bootstrap() async throws {}

    public static func shutdown() async throws {}
}
