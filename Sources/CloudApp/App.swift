import Foundation
import Logging
import ServiceLifecycle

public typealias ServiceConfiguration = ServiceGroupConfiguration.ServiceConfiguration

public protocol App {

    static func services() async throws -> [ServiceConfiguration]

    /// Log level to be used when bootstrapping the logging system.
    ///
    /// Default implementation uses `CloudBootstrap.defaultLogLevel`: `.debug` for debug builds and `.info` for release
    /// builds, unless the `LOG_LEVEL`-environment variable is present.
    static var logLevel: Logger.Level { get }

    /// Configuration used when bootstrapping the metrics system.
    ///
    /// Default implementation uses the default `MetricsConfiguration`.
    static var metricsConfiguration: MetricsConfiguration { get }
}

// MARK: - Default implementations

extension App {

    public static var logLevel: Logger.Level {
        CloudBootstrap.defaultLogLevel
    }

    public static var metricsConfiguration: MetricsConfiguration {
        MetricsConfiguration()
    }
}
