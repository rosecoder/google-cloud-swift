SOURCES_ROOT="$(pwd)/Sources"

rm -rf ${SOURCES_ROOT}/*/gRPC_generated/*

cd googleapis/

echo "Generating gRPC code for Logger..."
protoc google/logging/v2/*.proto google/logging/type/*.proto google/api/monitored_resource.proto google/api/metric.proto google/api/distribution.proto google/api/label.proto google/api/launch_stage.proto google/rpc/status.proto google/longrunning/operations.proto \
  --swift_out=${SOURCES_ROOT}/CloudLogger/gRPC_generated/ \
  --grpc-swift_opt=Client=true,Server=false \
  --grpc-swift_out=${SOURCES_ROOT}/CloudLogger/gRPC_generated/

echo "Generating gRPC code for PubSub..."
protoc google/pubsub/v1/*.proto \
  --swift_out=${SOURCES_ROOT}/CloudPubSub/gRPC_generated/ \
  --grpc-swift_opt=Client=true,Server=false \
  --grpc-swift_out=${SOURCES_ROOT}/CloudPubSub/gRPC_generated/

echo "Generating gRPC code for Datastore..."
protoc google/datastore/v1/*.proto google/type/latlng.proto \
  --swift_opt=Visibility=Package \
  --swift_out=${SOURCES_ROOT}/CloudDatastore/gRPC_generated/ \
  --grpc-swift_opt=Client=true,Server=false \
  --grpc-swift_opt=Visibility=Package \
  --grpc-swift_out=${SOURCES_ROOT}/CloudDatastore/gRPC_generated/

echo "Generating gRPC code for Trace..."
protoc google/devtools/cloudtrace/v2/*.proto google/rpc/status.proto \
  --swift_out=${SOURCES_ROOT}/CloudTrace/gRPC_generated/ \
  --grpc-swift_opt=Client=true,Server=false \
  --grpc-swift_out=${SOURCES_ROOT}/CloudTrace/gRPC_generated/

echo "Generating gRPC code for AI platform..."
protoc google/cloud/aiplatform/v1/*.proto google/rpc/status.proto google/longrunning/operations.proto google/api/httpbody.proto google/type/date.proto google/type/money.proto google/type/interval.proto \
  --swift_opt=Visibility=Public \
  --swift_out=${SOURCES_ROOT}/CloudAIPlatform/gRPC_generated/ \
  --grpc-swift_opt=Client=true,Server=false \
  --grpc-swift_opt=Visibility=Public \
  --grpc-swift_out=${SOURCES_ROOT}/CloudAIPlatform/gRPC_generated/
