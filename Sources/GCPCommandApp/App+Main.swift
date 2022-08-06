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
    public func commandMain(bootstrap: @escaping () async throws -> Void = {}) {
        commandApp = self
        initialize(bootstrap: bootstrap, completion: {
            await Self.main()
            terminate(exitCode: 0)
        })
    }
}
