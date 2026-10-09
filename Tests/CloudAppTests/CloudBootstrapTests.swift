import Testing
import Logging
import GoogleCloudMetrics
@testable import CloudApp

@Suite(.serialized)
struct CloudBootstrapTests {

    @Test func bootstrapIsIdempotent() {
        let first = CloudBootstrap.bootstrap(logLevel: .notice)
        let second = CloudBootstrap.bootstrap(logLevel: .trace, metrics: .init(exportInterval: .seconds(10)))

        #expect(first.isEmpty, "Debug builds should not bootstrap telemetry services")
        #expect(second.count == first.count)

        let logger = Logger(label: "test")
        #expect(logger.handler is StreamLogHandler)
        #expect(logger.logLevel == .notice, "Only the first bootstrap should apply")
    }

    @Test func defaultMetricsConfigurationNeedsNoChanges() throws {
        let factory = try CloudBootstrap.makeMetricsFactory(configuration: .init())

        #expect(factory.exportInterval == .seconds(60))
        #expect(factory.shutdownTimeout == .seconds(8))
        #expect(factory.idleExpiration == .default)
        #expect(factory.idleExpiration?.after == .zero)
        #expect(factory.timerBuckets == .defaultTimer)
        #expect(factory.recorderBuckets == .defaultRecorder)
    }

    @Test func metricsConfigurationMapsOntoFactory() throws {
        let configuration = MetricsConfiguration(
            exportInterval: .seconds(30),
            shutdownTimeout: .seconds(3),
            idleExpiration: IdleExpiration(after: .seconds(120), kinds: [.counters, .gauges]),
            timerBuckets: .explicit(bounds: [1, 10, 100]),
            recorderBuckets: .exponential(count: 4, growthFactor: 2, scale: 1)
        )

        let factory = try CloudBootstrap.makeMetricsFactory(configuration: configuration)

        #expect(factory.exportInterval == .seconds(30))
        #expect(factory.shutdownTimeout == .seconds(3))
        #expect(factory.idleExpiration == IdleExpiration(after: .seconds(120), kinds: [.counters, .gauges]))
        #expect(factory.timerBuckets == .explicit(bounds: [1, 10, 100]))
        #expect(factory.recorderBuckets == .exponential(count: 4, growthFactor: 2, scale: 1))
    }

    @Test func disabledIdleExpirationMapsOntoFactory() throws {
        let factory = try CloudBootstrap.makeMetricsFactory(configuration: .init(idleExpiration: nil))

        #expect(factory.idleExpiration == nil)
    }
}
