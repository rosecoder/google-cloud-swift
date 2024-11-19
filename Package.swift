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

        // Infrastructure
        .library(name: "CloudErrorReporting", targets: ["CloudErrorReporting"]),

        // Services
        .library(name: "CloudAIPlatform", targets: ["CloudAIPlatform"]),
        .library(name: "CloudDatastore", targets: ["CloudDatastore"]),
        .library(name: "CloudRedis", targets: ["CloudRedis"]),
        .library(name: "CloudPubSub", targets: ["CloudPubSub"]),
        .library(name: "CloudStorage", targets: ["CloudStorage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.1.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", branch: "main"),
        .package(url: "https://github.com/rosecoder/grpc-swift-nio-transport.git", branch: "authority-header"),
        .package(url: "https://github.com/grpc/grpc-swift-extras.git", branch: "main"),
        .package(url: "https://github.com/rosecoder/google-cloud-auth-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/rosecoder/google-cloud-logging-swift.git", revision: "b5257334667b4b3a35faff1d555b242df089bc4a"),
        .package(url: "https://github.com/rosecoder/google-cloud-tracing-swift.git", revision: "4a24d584d3fce322de44e1253348d0c53b11da10"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0"),
        .package(url: "https://github.com/swift-server/RediStack.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/rosecoder/retryable-task.git", from: "1.1.2"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.54.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.3.0"),
    ],
    targets: [
        .target(name: "CloudAIPlatform", dependencies: [
            "CloudCore",
        ] + grpcDependencies),

        .target(name: "CloudApp", dependencies: [
            "CloudCore",
            "CloudErrorReporting",
            .product(name: "GoogleCloudLogging", package: "google-cloud-logging-swift"),
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

        .target(name: "CloudErrorReporting", dependencies: [
            "CloudCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "CloudErrorReportingTests", dependencies: ["CloudErrorReporting"]),

        .target(name: "CloudRedis", dependencies: [
            "CloudCore",
            .product(name: "RediStack", package: "RediStack"),
        ] + infrastructureDependencies),
        .testTarget(name: "CloudRedisTests", dependencies: ["CloudRedis"]),

        .target(name: "CloudPubSub", dependencies: [
            "CloudCore",
            .product(name: "NIOHTTP1", package: "swift-nio"),
        ] + grpcDependencies + infrastructureDependencies),
        .testTarget(name: "CloudPubSubTests", dependencies: ["CloudPubSub"]),

        .target(name: "CloudStorage", dependencies: [
            "CloudCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto"),
        ] + infrastructureDependencies),
        .testTarget(name: "CloudStorageTests", dependencies: ["CloudStorage"]),
    ]
)
