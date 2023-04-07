// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "google-cloud-swift",
    platforms: [
       .macOS("12.0"),
    ],
    products: [
        .library(name: "GCPApp", targets: ["GCPApp"]),
        .library(name: "GCPCommandApp", targets: ["GCPCommandApp"]),
        .library(name: "GCPCore", targets: ["GCPCore"]),
        .library(name: "GCPDatastore", targets: ["GCPDatastore"]),
        .library(name: "GCPLogging", targets: ["GCPLogging"]),
        .library(name: "GCPMySQL", targets: ["GCPMySQL"]),
        .library(name: "GCPRedis", targets: ["GCPRedis"]),
        .library(name: "GCPPubSub", targets: ["GCPPubSub"]),
        .library(name: "GCPStorage", targets: ["GCPStorage"]),
        .library(name: "GCPTrace", targets: ["GCPTrace"]),
    ],
    dependencies: [
        .package(name: "swift-log", url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", .revision("1.8.0")),
        .package(name: "Auth", url: "https://github.com/rosecoder/google-auth-library-swift.git", .revision("6f80a45bb058999f55af3935c38c3460c9e5aad2")),
        .package(name: "async-http-client", url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0"),
        .package(name: "RediStack", url: "https://gitlab.com/mordil/RediStack.git", from: "1.0.0"),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(name: "retryable-task", url: "https://github.com/rosecoder/retryable-task.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/mysql-nio.git", from: "1.4.0"),
    ],
    targets: [
        .target(name: "GCPApp", dependencies: [
            "GCPCore",
            "GCPErrorReporting",
            "GCPLogging",
            "GCPTrace",
            .product(name: "Logging", package: "swift-log"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "GCPAppTests", dependencies: ["GCPApp"]),

        .target(name: "GCPCommandApp", dependencies: [
            "GCPApp",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),

        .target(name: "GCPCore", dependencies: [
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "OAuth2Server", package: "Auth"),
            .product(name: "RetryableTask", package: "retryable-task"),
        ]),
        .testTarget(name: "GCPCoreTests", dependencies: ["GCPCore"]),

        .target(name: "GCPDatastore", dependencies: [
            "GCPCore",
            "GCPTrace",
            .product(name: "GRPC", package: "grpc-swift"),
        ]),
        .testTarget(name: "GCPDatastoreTests", dependencies: ["GCPDatastore"]),

        .target(name: "GCPErrorReporting", dependencies: [
            "GCPCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "GCPErrorReportingTests", dependencies: ["GCPErrorReporting"]),

        .target(name: "GCPLogging", dependencies: [
            "GCPCore",
            "GCPErrorReporting",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "GCPLoggingTests", dependencies: ["GCPLogging"]),

        .target(name: "GCPMySQL", dependencies: [
            "GCPCore",
            "GCPTrace",
            .product(name: "MySQLNIO", package: "mysql-nio"),
        ]),
        .testTarget(name: "GCPMySQLTests", dependencies: ["GCPMySQL"]),

        .target(name: "GCPRedis", dependencies: [
            "GCPCore",
            "GCPTrace",
            .product(name: "RediStack", package: "RediStack"),
        ]),
        .testTarget(name: "GCPRedisTests", dependencies: ["GCPRedis"]),

        .target(name: "GCPPubSub", dependencies: [
            "GCPCore",
            "GCPTrace",
            .product(name: "GRPC", package: "grpc-swift"),
        ]),
        .testTarget(name: "GCPPubSubTests", dependencies: ["GCPPubSub"]),

        .target(name: "GCPStorage", dependencies: [
            "GCPCore",
            "GCPTrace",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "GCPStorageTests", dependencies: ["GCPStorage"]),

        .target(name: "GCPTrace", dependencies: [
            "GCPCore",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "GCPTraceTests", dependencies: ["GCPTrace"]),
    ]
)
