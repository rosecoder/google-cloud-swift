import Foundation
import Logging
import Metrics
import Tracing
import ServiceLifecycle
import Synchronization
import GoogleCloudLogging
import GoogleCloudErrorReporting
import GoogleCloudTracing
import GoogleCloudMetrics
import GoogleCloudServiceContext

/// Bootstraps logging, tracing and metrics for the process.
///
/// `App.main()` calls this automatically. Services not using `App` (for example Hummingbird applications) should call
/// it at the very top of `main.swift`, before any `Logger` or metric is created, and run the returned services:
///
/// ```swift
/// let app = Application(router: router, services: CloudBootstrap.bootstrap().services)
/// ```
public enum CloudBootstrap {

#if DEBUG
    static var configureForProduction: Bool { false }
#else
    static var configureForProduction: Bool { true }
#endif

    private static let bootstrappedServices = Mutex<[ServiceConfiguration]?>(nil)

    /// Bootstraps `LoggingSystem`, `InstrumentationSystem` and `MetricsSystem` and returns the services that must run
    /// for logs, traces and metrics to be exported.
    ///
    /// Release builds export to Google Cloud Logging, Error Reporting, Cloud Trace and Cloud Monitoring. Debug builds
    /// only bootstrap logging to standard output and return no services.
    ///
    /// Idempotent: only the first call bootstraps. Later calls return the same services and ignore their arguments.
    /// The returned services must only be run once.
    public static func bootstrap(
        logLevel: Logger.Level = defaultLogLevel,
        metrics: MetricsConfiguration = .init()
    ) -> [ServiceConfiguration] {
        bootstrappedServices.withLock { bootstrappedServices in
            if let bootstrappedServices {
                return bootstrappedServices
            }
            let services = bootstrapSystems(logLevel: logLevel, metrics: metrics)
            bootstrappedServices = services
            return services
        }
    }

    /// Log level used when none is given.
    ///
    /// `.debug` for debug builds and `.info` for release builds, unless the `LOG_LEVEL`-environment variable is present.
    ///
    /// The `LOG_LEVEL`-environment variable can have the following values (not case sensitive):
    /// - trace
    /// - debug
    /// - info
    /// - notice
    /// - warning
    /// - error
    /// - critical
    public static var defaultLogLevel: Logger.Level {
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

    private static func bootstrapSystems(logLevel: Logger.Level, metrics: MetricsConfiguration) -> [ServiceConfiguration] {
        guard configureForProduction else {
            bootstrapDebugLogging(logLevel: logLevel)
            return []
        }

        let serviceContextResolver = ServiceConfiguration(service: GoogleServiceContextResolver())
        let errorReporting = bootstrapProductionLogging(logLevel: logLevel)

        var logger = Logger(label: "cloud.bootstrap")
        logger.logLevel = logLevel

        let services: [ServiceConfiguration?] = [
            serviceContextResolver,
            errorReporting,
            bootstrapTracing(logger: logger),
            bootstrapMetrics(configuration: metrics, logger: logger),
        ]
        return services.compactMap { $0 }
    }

    private static func bootstrapDebugLogging(logLevel: Logger.Level) {
        LoggingSystem.bootstrap { label in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = logLevel
            return handler
        }
    }

    private static func bootstrapProductionLogging(logLevel: Logger.Level) -> ServiceConfiguration {
        let errorReportingService = ErrorReportingService()

        LoggingSystem.bootstrap { label in
            var logHandler = GoogleCloudLogHandler(label: label)
            logHandler.logLevel = logLevel

            var errorReportingHandler = ErrorReportingLogHandler(service: errorReportingService, label: label)
            errorReportingHandler.logLevel = .error

            return MultiplexLogHandler([
                logHandler,
                errorReportingHandler,
            ])
        }

        return .init(service: errorReportingService)
    }

    private static func bootstrapTracing(logger: Logger) -> ServiceConfiguration? {
        do {
            let tracer = try GoogleCloudTracer()
            InstrumentationSystem.bootstrap(tracer)
            return .init(service: tracer)
        } catch {
            logger.warning("Tracer (optional) failed to bootstrap: \(error)")
            return nil
        }
    }

    private static func bootstrapMetrics(configuration: MetricsConfiguration, logger: Logger) -> ServiceConfiguration? {
        do {
            let factory = try makeMetricsFactory(configuration: configuration)
            MetricsSystem.bootstrap(factory)
            return .init(service: factory)
        } catch {
            logger.warning("Metrics (optional) failed to bootstrap: \(error)")
            return nil
        }
    }

    static func makeMetricsFactory(configuration: MetricsConfiguration) throws -> GoogleCloudMetricsFactory {
        try GoogleCloudMetricsFactory(
            exportInterval: configuration.exportInterval,
            shutdownTimeout: configuration.shutdownTimeout,
            timerBuckets: configuration.timerBuckets,
            recorderBuckets: configuration.recorderBuckets,
            idleExpiration: configuration.idleExpiration
        )
    }
}

extension Array where Element == ServiceConfiguration {

    /// The services of the configurations, for adding to a service group not created by `App` (such as Hummingbird's
    /// `Application`).
    public var services: [any Service] {
        map(\.service)
    }
}
