import RetryableTask

var commandApp: App?

extension App {

    /// Intiaizlies the app with all bootstrapping defined for a single action run. After this the app is terminated with exit code 0.
    /// - Parameter action: Action to run after bootstrap.
    ///
    /// Boostrapping order:
    /// - Logging
    /// - Error reporting
    /// - Tracing
    /// - Metrics
    /// - App dependencies
    public func commandMain(bootstrap: @escaping () async throws -> Void = {}) async -> Never {
        commandApp = self

        // Retries
        DefaultRetryPolicy.retryPolicy = ExponentialBackoffDelayRetryPolicy(
            minimumBackoffDelay: 200_000_000, // 200 ms
            maximumBackoffDelay: 5_000_000_000, // 5 000 ms
            maxRetries: 7
        )

        // Init
        await initialize(bootstrap: bootstrap)

        // Execute
        await Self.main()

        // Terminate
        await terminate(exitCode: 0)
    }
}