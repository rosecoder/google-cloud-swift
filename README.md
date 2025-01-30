# Google Cloud Swift

This project is work currently in progress and being split up into multiple repositories.

The vision for this project is to provide a high-level implementation of Google Cloud services in Swift, initially focusing on supporting running on Cloud Run and GKE. Packages configures logging, error reporting and tracing using the community packages [swift-log](https://github.com/apple/swift-log) and [swift-distributed-tracing](https://github.com/apple/swift-distributed-tracing). Support for metrics to Stackdriver is planned.

## Packages

### Google Services

- [BigQuery](https://github.com/rosecoder/google-cloud-bigquery-swift)
- Cloud Storage (will move to separate repository in the future)
- [Datastore (Google Cloud Firestore in Datastore mode)](https://github.com/rosecoder/google-cloud-datastore-swift)
- [Pub/Sub](https://github.com/rosecoder/google-cloud-pubsub-swift)

### Infrastructure

These are automatically configured when using this package.

- [Authentication](https://github.com/rosecoder/google-cloud-auth-swift)
- [Logging](https://github.com/rosecoder/google-cloud-logging-swift)
- [Error Reporting](https://github.com/rosecoder/google-cloud-error-reporting-swift)
- [Tracing](https://github.com/rosecoder/google-cloud-tracing-swift)

## License

MIT License. See [LICENSE](./LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
