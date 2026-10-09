# Google Cloud Swift

This project is work currently in progress and being split up into multiple repositories.

The vision for this project is to provide a high-level implementation of Google Cloud services in Swift, initially focusing on supporting running on Cloud Run and GKE. Packages configures logging, error reporting, tracing and metrics using the community packages [swift-log](https://github.com/apple/swift-log), [swift-distributed-tracing](https://github.com/apple/swift-distributed-tracing) and [swift-metrics](https://github.com/apple/swift-metrics).

## Packages

### Google Services

- [BigQuery](https://github.com/rosecoder/google-cloud-bigquery-swift)
- [Cloud Storage](https://github.com/rosecoder/google-cloud-storage-swift)
- [Datastore (Google Cloud Firestore in Datastore mode)](https://github.com/rosecoder/google-cloud-datastore-swift)
- [Pub/Sub](https://github.com/rosecoder/google-cloud-pubsub-swift)

### Infrastructure

These are automatically configured when using this package.

- [Authentication](https://github.com/rosecoder/google-cloud-auth-swift)
- [Logging](https://github.com/rosecoder/google-cloud-logging-swift)
- [Error Reporting](https://github.com/rosecoder/google-cloud-error-reporting-swift)
- [Tracing](https://github.com/rosecoder/google-cloud-tracing-swift)
- [Metrics](https://github.com/rosecoder/google-cloud-metrics-swift)

## Usage

Release builds export logs to Cloud Logging, errors to Error Reporting, traces to Cloud Trace and metrics to Cloud Monitoring. Debug builds only log to standard output.

### Apps

Conform to `CloudApp.App` and call `main()`. Telemetry is bootstrapped before `services()` is called, and its services shut down last, after your services.

```swift
import CloudApp

struct App: CloudApp.App {

    static func services() async throws -> [ServiceConfiguration] {
        [.init(service: myService)]
    }
}

try await App.main()
```

### Other services (for example Hummingbird)

Call `CloudBootstrap.bootstrap()` at the very top of `main.swift`, before any `Logger` or metric is created, and run the returned services in your service group. Add them first, so they shut down after the server has drained.

```swift
import CloudApp
import Hummingbird

let telemetryServices = CloudBootstrap.bootstrap()

var app = Application(router: router)
telemetryServices.services.forEach { app.addServices($0) }
try await app.runService()
```

The bootstrap is idempotent: later calls (including the one in `App.main()`) return the same services without bootstrapping again.

### Metrics configuration

No configuration is needed. Metrics are exported every 60 seconds, and inline counters and timers (`Counter(label:).increment()`) stop being exported after the export following their last update. Keep a reference to a `Counter`, `Meter`, etc. to export it continuously. To change this, pass a `MetricsConfiguration`:

```swift
// App
static var metricsConfiguration: MetricsConfiguration {
    MetricsConfiguration(idleExpiration: IdleExpiration(after: .seconds(300)))
}

// Other services
let telemetryServices = CloudBootstrap.bootstrap(metrics: MetricsConfiguration(idleExpiration: nil))
```

### Jobs

Register an `AsyncParsableCommand` with `.command(_:)`. The service group shuts down gracefully when the command finishes, whether it succeeds or fails, so metrics and traces of failed runs are still exported. Errors are logged, recorded on the command's span and rethrown, so the process exits with a non-zero status.

```swift
import ArgumentParser
import CloudApp
import CloudJob

struct App: CloudApp.App {

    static func services() async throws -> [ServiceConfiguration] {
        [
            .init(service: datastore),
            .command(Commands.self),
        ]
    }
}

try await App.main()
```

## License

MIT License. See [LICENSE](./LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
