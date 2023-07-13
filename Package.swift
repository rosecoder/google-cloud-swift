// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "google-cloud-swift",
    platforms: [
       .macOS("12.0"),
    ],
    products: [
        .library(name: "CloudCore", targets: ["CloudCore", "Trace"]),
        .library(name: "CloudApp", targets: ["CloudApp", "CloudCore", "Trace"]),
        .library(name: "CloudJob", targets: ["CloudJob", "CloudCore", "Trace"]),

        // Infrastructure
        .library(name: "ErrorReporting", targets: ["ErrorReporting"]),
        .library(name: "Logger", targets: ["Logger"]),
        .library(name: "Trace", targets: ["Trace"]),

        // Services
        .library(name: "Datastore", targets: ["Datastore"]),
        .library(name: "MySQL", targets: ["MySQL"]),
        .library(name: "Redis", targets: ["Redis"]),
        .library(name: "PubSub", targets: ["PubSub"]),
        .library(name: "Storage", targets: ["Storage"]),
        .library(name: "Translation", targets: ["Translation"]),
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
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.54.0"),
    ],
    targets: [
        .target(name: "CloudApp", dependencies: [
            "CloudCore",
            "ErrorReporting",
            "Logger",
            "Trace",
            .product(name: "Logging", package: "swift-log"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
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
        ]),
        .testTarget(name: "CoreTests", dependencies: ["CloudCore"]),

        .target(name: "Datastore", dependencies: [
            "CloudCore",
            "Trace",
            .product(name: "GRPC", package: "grpc-swift"),
        ]),
        .testTarget(name: "DatastoreTests", dependencies: ["Datastore"]),

        .target(name: "ErrorReporting", dependencies: [
            "CloudCore",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "ErrorReportingTests", dependencies: ["ErrorReporting"]),

        .target(name: "Logger", dependencies: [
            "CloudCore",
            "ErrorReporting",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "LoggerTests", dependencies: ["Logger"]),

        .target(name: "MySQL", dependencies: [
            "CloudCore",
            "Trace",
            .product(name: "MySQLNIO", package: "mysql-nio"),
        ]),
        .testTarget(name: "MySQLTests", dependencies: ["MySQL"]),

        .target(name: "Redis", dependencies: [
            "CloudCore",
            "Trace",
            .product(name: "RediStack", package: "RediStack"),
        ]),
        .testTarget(name: "RedisTests", dependencies: ["Redis"]),

        .target(name: "PubSub", dependencies: [
            "CloudCore",
            "Trace",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "NIOHTTP1", package: "swift-nio"),
        ]),
        .testTarget(name: "PubSubTests", dependencies: ["PubSub"]),

        .target(name: "Storage", dependencies: [
            "CloudCore",
            "Trace",
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "StorageTests", dependencies: ["Storage"]),

        .target(name: "Trace", dependencies: [
            "CloudCore",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "TraceTests", dependencies: ["Trace"]),

        .target(name: "Translation", dependencies: [
            "CloudCore",
            "Trace",
        ]),
        .testTarget(name: "TranslationTests", dependencies: ["Translation"]),
    ]
)
