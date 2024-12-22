// swift-tools-version:6.0
import PackageDescription

let infrastructureDependencies: [Target.Dependency] = [
    .product(name: "Logging", package: "swift-log"),
    .product(name: "Metrics", package: "swift-metrics"),
    .product(name: "Tracing", package: "swift-distributed-tracing"),
    .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
]

let grpcDependencies: [Target.Dependency] = [
    .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
    .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
]

let package = Package(
    name: "google-cloud-swift",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "CloudCore", targets: ["CloudCore"]),
        .library(name: "CloudApp", targets: ["CloudApp"]),
        .library(name: "CloudJob", targets: ["CloudJob"]),

        // Services
        .library(name: "CloudAIPlatform", targets: ["CloudAIPlatform"]),
        .library(name: "CloudDatastore", targets: ["CloudDatastore"]),
        .library(name: "CloudDatastoreTesting", targets: ["CloudDatastoreTesting"]),
        .library(name: "CloudRedis", targets: ["CloudRedis"]),
        .library(name: "CloudPubSub", targets: ["CloudPubSub"]),
        .library(name: "CloudPubSubTesting", targets: ["CloudPubSubTesting"]),
        .library(name: "CloudStorage", targets: ["CloudStorage"]),
        .library(name: "CloudStorageTesting", targets: ["CloudStorageTesting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.1.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "1.0.0-beta.2"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "1.0.0-beta.2"),
        .package(url: "https://github.com/grpc/grpc-swift-extras.git", from: "1.0.0-beta.2"),
        .package(url: "https://github.com/rosecoder/google-cloud-logging-swift.git", from: "0.0.1"),
        .package(url: "https://github.com/rosecoder/google-cloud-error-reporting-swift.git", from: "0.0.1"),
        .package(url: "https://github.com/rosecoder/google-cloud-tracing-swift.git", from: "0.0.3"),
        .package(url: "https://github.com/rosecoder/google-cloud-auth-swift.git", from: "1.0.1"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0"),
        .package(url: "https://github.com/swift-server/RediStack.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/rosecoder/retryable-task.git", from: "1.1.2"),
        .package(url: "https://github.com/rosecoder/distributed-lock-swift.git", from: "0.0.2"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.54.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.3.0"),
    ],
    targets: [
        .target(name: "CloudAIPlatform", dependencies: [
            "CloudCore",
        ] + grpcDependencies),

        .target(name: "CloudApp", dependencies: [
            "CloudCore",
            .product(name: "GoogleCloudLogging", package: "google-cloud-logging-swift"),
            .product(name: "GoogleCloudErrorReporting", package: "google-cloud-error-reporting-swift"),
            .product(name: "GoogleCloudTracing", package: "google-cloud-tracing-swift"),
            .product(name: "GRPCInterceptors", package: "grpc-swift-extras"),
        ] + infrastructureDependencies),
        .testTarget(name: "CloudAppTests", dependencies: ["CloudApp"]),

        .target(name: "CloudJob", dependencies: [
            "CloudApp",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),

        .target(name: "CloudCore", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            .product(name: "GoogleCloudAuth", package: "google-cloud-auth-swift"),
            .product(name: "RetryableTask", package: "retryable-task"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ] + grpcDependencies),
        .testTarget(name: "CoreTests", dependencies: ["CloudCore"]),

        .target(name: "CloudDatastore", dependencies: [
            "CloudCore",
        ] + grpcDependencies + infrastructureDependencies),
        .testTarget(name: "CloudDatastoreTests", dependencies: ["CloudDatastore"]),

        .target(name: "CloudDatastoreTesting", dependencies: [
            "CloudDatastore",
        ]),

        .target(name: "CloudRedis", dependencies: [
            "CloudCore",
            .product(name: "DistributedLock", package: "distributed-lock-swift"),
            .product(name: "RediStack", package: "RediStack"),
        ] + infrastructureDependencies),
        .testTarget(name: "CloudRedisTests", dependencies: ["CloudRedis"]),

        .target(name: "CloudPubSub", dependencies: [
            "CloudCore",
            .product(name: "NIOHTTP1", package: "swift-nio"),
        ] + grpcDependencies + infrastructureDependencies),
        .testTarget(name: "CloudPubSubTests", dependencies: ["CloudPubSub"]),

        .target(name: "CloudPubSubTesting", dependencies: [
            "CloudPubSub",
        ]),

        .target(name: "CloudStorage", dependencies: [
            "CloudCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto"),
        ] + infrastructureDependencies),
        .testTarget(name: "CloudStorageTests", dependencies: ["CloudStorage"]),

        .target(name: "CloudStorageTesting", dependencies: [
            "CloudStorage",
        ]),
    ]
)
