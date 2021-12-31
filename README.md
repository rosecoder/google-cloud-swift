# google-cloud-swift

This project is work in progress and should not be used in production.

## Development

### Updating gRPC-generated Swift-soruces.

1. Make sure the submodule `googleapis` is checked out.
2. Make sure executable `protoc` is installed.
3. Make sure swift plugins for protoc is installed (`protoc-gen-swift` and `protoc-gen-swiftgrpc`)
4. `./generate-grpc.bash`
