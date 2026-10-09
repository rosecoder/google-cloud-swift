@_exported import struct GoogleCloudMetrics.IdleExpiration
@_exported import struct GoogleCloudMetrics.DistributionBuckets

/// Configuration of the metrics exported to Google Cloud Monitoring. The defaults need no changes for most services.
public struct MetricsConfiguration: Sendable {

    /// Interval between exports. Must be at least 5 seconds.
    public var exportInterval: Duration

    /// Maximum time spent exporting remaining metrics on graceful shutdown.
    public var shutdownTimeout: Duration

    /// When metrics which are no longer referenced stop being exported. `nil` keeps them until destroyed.
    public var idleExpiration: IdleExpiration?

    /// Buckets used for timers. Timers are exported in milliseconds.
    public var timerBuckets: DistributionBuckets

    /// Buckets used for aggregating recorders.
    public var recorderBuckets: DistributionBuckets

    public init(
        exportInterval: Duration = .seconds(60),
        shutdownTimeout: Duration = .seconds(8),
        idleExpiration: IdleExpiration? = .default,
        timerBuckets: DistributionBuckets = .defaultTimer,
        recorderBuckets: DistributionBuckets = .defaultRecorder
    ) {
        self.exportInterval = exportInterval
        self.shutdownTimeout = shutdownTimeout
        self.idleExpiration = idleExpiration
        self.timerBuckets = timerBuckets
        self.recorderBuckets = recorderBuckets
    }
}
