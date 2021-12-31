# GoogleCloudLogging

This project is work in progress and should not be used in production.

GoogleCloudLogging is intended to be used with [SwiftLog](https://github.com/apple/swift-log).

## Setup Logging

1. Import `SwiftLog` an `GoogleCloudLogging`:

```
import Logging
import GoogleCloudLogging
```

2. Setup 

## Development

### Updating gRPC-generated Swift-soruces.

1. Make sure the submodule `googleapis` is checked out.
2. Make sure executable `protoc` is installed.
3. Make sure swift plugins for protoc is installed (`protoc-gen-swift` and `protoc-gen-swiftgrpc`)
4. 
```bash
cd googleapis/

protoc google/logging/v2/*.proto google/logging/type/*.proto google/api/monitored_resource.proto google/api/metric.proto google/api/distribution.proto google/api/label.proto google/api/launch_stage.proto google/rpc/status.proto \
  --swift_out=. \
  --grpc-swift_out=Client=true,Server=false,ExperimentalAsyncClient=true:.
  
rm ../Sources/GoogleCloudLogging/gRPC\ Generated/*.swift
mv google/logging/v2/*.swift google/logging/type/*.swift google/api/*.swift google/rpc/*.swift \
   ../Sources/GoogleCloudLogging/gRPC\ Generated

```
