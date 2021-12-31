cd googleapis/

echo "Generating gRPC code for GCPLogging..."
protoc google/logging/v2/*.proto google/logging/type/*.proto google/api/monitored_resource.proto google/api/metric.proto google/api/distribution.proto google/api/label.proto google/api/launch_stage.proto google/rpc/status.proto \
  --swift_out=. \
  --grpc-swift_out=Client=true,Server=false,ExperimentalAsyncClient=true:.

rm ../Sources/GCPLogging/gRPC\ Generated/*.swift
mv google/logging/v2/*.swift google/logging/type/*.swift google/api/*.swift google/rpc/*.swift \
   ../Sources/GCPLogging/gRPC\ Generated

echo "Generating gRPC code for GCPPubSub..."
protoc google/pubsub/v1/*.proto \
 --swift_out=. \
 --grpc-swift_out=Client=true,Server=false,ExperimentalAsyncClient=true:.

rm ../Sources/GCPPubSub/gRPC\ Generated/*.swift
mv google/pubsub/v1/*.swift \
  ../Sources/GCPPubSub/gRPC\ Generated
