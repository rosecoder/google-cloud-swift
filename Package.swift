// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "google-cloud-swift",
    platforms: [
       .macOS("12.0"),
    ],
    products: [
        .library(name: "CloudCore", targets: ["CloudCore"]),
        .library(name: "CloudApp", targets: ["CloudApp"]),
        .library(name: "CloudJob", targets: ["CloudJob"]),

        // Infrastructure
        .library(name: "CloudErrorReporting", targets: ["CloudErrorReporting"]),
        .library(name: "CloudLogger", targets: ["CloudLogger"]),
        .library(name: "CloudTrace", targets: ["CloudTrace"]),

        // Services
        .library(name: "CloudDatastore", targets: ["CloudDatastore"]),
        .library(name: "CloudMySQL", targets: ["CloudMySQL"]),
        .library(name: "CloudRedis", targets: ["CloudRedis"]),
        .library(name: "CloudPubSub", targets: ["CloudPubSub"]),
        .library(name: "CloudStorage", targets: ["CloudStorage"]),
        .library(name: "CloudTranslation", targets: ["CloudTranslation"]),
    ],
    dependencies: [
        .package(name: "swift-log", url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", .revision("1.8.0")),
        .package(name: "Auth", url: "https://github.com/rosecoder/google-auth-library-swift.git", .revision("3a8e3c6d3141ba38017b2b87cb6961ac97360b62")),
        .package(name: "async-http-client", url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0"),
        .package(name: "RediStack", url: "https://gitlab.com/mordil/RediStack.git", from: "1.0.0"),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(name: "retryable-task", url: "https://github.com/rosecoder/retryable-task.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/mysql-nio.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.54.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "2.5.0"),
    ],
    targets: [
        .target(name: "CloudApp", dependencies: [
            "CloudCore",
            "CloudErrorReporting",
            "CloudLogger",
            "CloudTrace",
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "CloudAppTests", dependencies: ["CloudApp"]),

        .target(name: "CloudJob", dependencies: [
            "CloudApp",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),

        .target(name: "CloudCore", dependencies: [
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "OAuth2Server", package: "Auth"),
            .product(name: "RetryableTask", package: "retryable-task"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "CoreTests", dependencies: ["CloudCore"]),

        .target(name: "CloudDatastore", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "GRPC", package: "grpc-swift"),
        ]),
        .testTarget(name: "CloudDatastoreTests", dependencies: ["CloudDatastore"]),

        .target(name: "CloudErrorReporting", dependencies: [
            "CloudCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "CloudErrorReportingTests", dependencies: ["CloudErrorReporting"]),

        .target(name: "CloudLogger", dependencies: [
            "CloudCore",
            "CloudErrorReporting",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "CloudLoggerTests", dependencies: ["CloudLogger"]),

        .target(name: "CloudMySQL", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "MySQLNIO", package: "mysql-nio"),
        ]),
        .testTarget(name: "CloudMySQLTests", dependencies: ["CloudMySQL"]),

        .target(name: "CloudRedis", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "RediStack", package: "RediStack"),
        ]),
        .testTarget(name: "CloudRedisTests", dependencies: ["CloudRedis"]),

        .target(name: "CloudPubSub", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "NIOHTTP1", package: "swift-nio"),
        ]),
        .testTarget(name: "CloudPubSubTests", dependencies: ["CloudPubSub"]),

        .target(name: "CloudStorage", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto"),
        ]),
        .testTarget(name: "CloudStorageTests", dependencies: ["CloudStorage"]),

        .target(name: "CloudTrace", dependencies: [
            "CloudCore",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "CloudTraceTests", dependencies: ["CloudTrace"]),

        .target(name: "CloudTranslation", dependencies: [
            "CloudCore",
            "CloudTrace",
        ]),
        .testTarget(name: "CloudTranslationTests", dependencies: ["CloudTranslation"]),
    ]
)
