cd googleapis/

echo "Generating gRPC code for Logger..."
protoc google/logging/v2/*.proto google/logging/type/*.proto google/api/monitored_resource.proto google/api/metric.proto google/api/distribution.proto google/api/label.proto google/api/launch_stage.proto google/rpc/status.proto google/longrunning/operations.proto \
  --swift_out=. \
  --grpc-swift_out=Client=true,Server=false:.

rm ../Sources/Logger/gRPC\ Generated/*.swift
mv google/logging/v2/*.swift google/logging/type/*.swift google/api/*.swift google/rpc/*.swift google/longrunning/*.swift \
   ../Sources/Logger/gRPC\ Generated

echo "Generating gRPC code for PubSub..."
protoc google/pubsub/v1/*.proto \
 --swift_out=. \
 --grpc-swift_out=Client=true,Server=false:.

rm ../Sources/PubSub/gRPC\ Generated/*.swift
mv google/pubsub/v1/*.swift \
  ../Sources/PubSub/gRPC\ Generated

echo "Generating gRPC code for Datastore..."
protoc google/datastore/v1/*.proto google/type/latlng.proto \
  --swift_out=. \
  --grpc-swift_out=Client=true,Server=false:.

rm ../Sources/Datastore/gRPC\ Generated/*.swift
mv google/datastore/v1/*.swift google/type/*.swift \
   ../Sources/Datastore/gRPC\ Generated

echo "Generating gRPC code for Trace..."
protoc google/devtools/cloudtrace/v2/*.proto google/rpc/status.proto \
  --swift_out=. \
  --grpc-swift_out=Client=true,Server=false:.

rm ../Sources/Trace/gRPC\ Generated/*.swift
mv google/devtools/cloudtrace/v2/*.swift google/rpc/*.swift \
   ../Sources/Trace/gRPC\ Generated

echo "Generating gRPC code for Translate..."
protoc google/cloud/translate/v3/*.proto google/rpc/status.proto google/longrunning/operations.proto \
  --swift_out=. \
  --grpc-swift_out=Client=true,Server=false:.

rm ../Sources/Translation/gRPC\ Generated/*.swift
mv google/cloud/translate/v3/*.swift google/rpc/*.swift google/longrunning/*.swift \
   ../Sources/Translation/gRPC\ Generated
