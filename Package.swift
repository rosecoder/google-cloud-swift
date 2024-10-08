// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "google-cloud-swift",
    platforms: [
        .macOS(.v13),
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
        .library(name: "CloudAIPlatform", targets: ["CloudAIPlatform"]),
        .library(name: "CloudDatastore", targets: ["CloudDatastore"]),
        .library(name: "CloudMySQL", targets: ["CloudMySQL"]),
        .library(name: "CloudRedis", targets: ["CloudRedis"]),
        .library(name: "CloudPubSub", targets: ["CloudPubSub"]),
        .library(name: "CloudStorage", targets: ["CloudStorage"]),
        .library(name: "CloudTranslation", targets: ["CloudTranslation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.8.0"),
        .package(url: "https://github.com/rosecoder/google-cloud-auth-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0"),
        .package(url: "https://gitlab.com/mordil/RediStack.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/rosecoder/retryable-task.git", from: "1.1.2"),
        .package(url: "https://github.com/vapor/mysql-nio.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.54.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.3.0"),
    ],
    targets: [
        .target(name: "CloudAIPlatform", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "GRPC", package: "grpc-swift"),
        ]),

        .target(name: "CloudApp", dependencies: [
            "CloudCore",
            "CloudErrorReporting",
            "CloudLogger",
            "CloudTrace",
            .product(name: "Logging", package: "swift-log"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudAppTests", dependencies: ["CloudApp"]),

        .target(name: "CloudJob", dependencies: [
            "CloudApp",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),

        .target(name: "CloudCore", dependencies: [
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "GoogleCloudAuth", package: "google-cloud-auth-swift"),
            .product(name: "RetryableTask", package: "retryable-task"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CoreTests", dependencies: ["CloudCore"]),

        .target(name: "CloudDatastore", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "GRPC", package: "grpc-swift"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudDatastoreTests", dependencies: ["CloudDatastore"]),

        .target(name: "CloudErrorReporting", dependencies: [
            "CloudCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudErrorReportingTests", dependencies: ["CloudErrorReporting"]),

        .target(name: "CloudLogger", dependencies: [
            "CloudCore",
            "CloudErrorReporting",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
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
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudPubSubTests", dependencies: ["CloudPubSub"]),

        .target(name: "CloudStorage", dependencies: [
            "CloudCore",
            "CloudTrace",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudStorageTests", dependencies: ["CloudStorage"]),

        .target(name: "CloudTrace", dependencies: [
            "CloudCore",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudTraceTests", dependencies: ["CloudTrace"]),

        .target(name: "CloudTranslation", dependencies: [
            "CloudCore",
            "CloudTrace",
        ], swiftSettings: [
            .enableExperimentalFeature("StrictConcurrency"),
        ]),
        .testTarget(name: "CloudTranslationTests", dependencies: ["CloudTranslation"]),
    ]
)
