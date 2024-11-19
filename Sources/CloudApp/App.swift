import Foundation
import Logging
import ServiceLifecycle

public typealias ServiceConfiguration = ServiceGroupConfiguration.ServiceConfiguration

public protocol App {

    static func services() async throws -> [ServiceConfiguration]

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
}

// MARK: - Default implementations

extension App {

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
}
