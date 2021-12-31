// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "google-cloud-swift",
    platforms: [
       .macOS("12.0"),
    ],
    products: [
        .library(name: "GCPApp", targets: ["GCPApp"]),
        .library(name: "GCPCore", targets: ["GCPCore"]),
        .library(name: "GCPLogging", targets: ["GCPLogging"]),
        .library(name: "GCPPubSub", targets: ["GCPPubSub"]),
    ],
    dependencies: [
        .package(name: "swift-log", url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", .revision("1.6.0-async-await.1")),
        .package(name: "Auth", url: "https://github.com/googleapis/google-auth-library-swift.git", from: "0.5.2"),
    ],
    targets: [
        .target(name: "GCPApp", dependencies: [
            "GCPCore",
            "GCPLogging",
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget( name: "GCPAppTests", dependencies: ["GCPApp"]),

        .target(name: "GCPCore", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            .product(name: "OAuth2", package: "Auth"),
        ]),
        .testTarget( name: "GCPCoreTests", dependencies: ["GCPCore"]),

        .target(name: "GCPLogging", dependencies: [
            "GCPCore",
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget( name: "GCPLoggingTests", dependencies: ["GCPLogging"]),

        .target(name: "GCPPubSub", dependencies: [
            "GCPCore",
            .product(name: "GRPC", package: "grpc-swift"),
        ]),
        .testTarget( name: "GCPPubSubTests", dependencies: ["GCPPubSub"]),
    ]
)
