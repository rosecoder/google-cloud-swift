# google-cloud-swift

This project is work in progress and should not be used in production.

## Packages in this repository

### GCPApp

This package includes infrastrucutre for running an app in GCP. The following packages are included and automatically bootstrapped:

- GCPLogging
- GCPErrorReporting
- GCPTrace

The following packages are planned to be added:

- ❌ GCPMetrics

### GCPLogging

Client for [Google Cloud Logging](https://cloud.google.com/logging). Implemented as a log handler for use with [swift-log](https://github.com/apple/swift-log). Sends it's logs directly to Cloud Logging via gRPC (not via stdout).

GCPLogging also sends errors to Error Reporting.

### GCPErrorReporting

Client for [Google Cloud Error Reporting](https://cloud.google.com/error-reporting). GCPLogging uses GCPErrorReporting to report all errors logged to error reporting as well.

### GCPTrace

Client for [Google Cloud Trace](https://cloud.google.com/trace).

| Feature                    | Implemented |
|:---------------------------|:------------|
| Create root spans          | ✅          |
| Create child spans         | ✅          |
| Attributes                 | ✅          |
| Same process property      | ✅          |
| Status reporting           | ✅          |
| Stack trace                | ❌          |
| Time events                | ❌          |
| Links                      | ❌          |
| Child span counting        | ❌          |
| Span kind                  | ❌          |
| Sampling                   | ❌          |

### GCPDatastore

Client for [Google Cloud Datastore](https://cloud.google.com/datastore). Focuses on really strong type safety which catches possible bugs on compile time. 

| Feature                    | Implemented |
|:---------------------------|:------------|
| Namespaces                 | ✅          |
| Get                        | ✅          |
| Put                        | ✅          |
| Delete                     | ✅          |
| Allocate/Reserve IDs       | ❌          |
| Transactions               | ❌          |
| Query                      | ✅          |
| Query - Cursors            | ❌          |
| Query - Projection         | ❌          |
| Query - Distinct on        | ❌          |
| GQL                        | ❌          |
| Trace reporting            | ✅          |

### GCPPubSub

Client for [Google Pub/Sub](https://cloud.google.com/pubsub).

| Feature                    | Implemented  |
|:---------------------------|:-------------|
| Publish messages           | ✅           |
| Subscribe to messages      | ✅           |
| Pub/Sub Lite               | ❌           |
| Error reporting            | ✅           |
| Trace reporting            | ✅           |

### GCPCore

Internal. This package implements common types used in all packages below like Auth. There is no real reason to use this directly.

## Development

### Updating gRPC-generated Swift-soruces.

Google APIs are included in this repository via a Git submodule. Update this submodule to get the latest APIs.

1. Make sure the submodule `googleapis` is checked out.
2. Make sure executable `protoc` is installed.
3. Make sure swift plugins for protoc is installed (`protoc-gen-swift` and `protoc-gen-swiftgrpc`)
4. `./generate-grpc.bash`
