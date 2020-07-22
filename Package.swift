// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GoogleCloudLogging",
    platforms: [
       .macOS(.v10_15),
    ],
    products: [
        .library(name: "GoogleCloudLogging", targets: ["GoogleCloudLogging"]),
    ],
    dependencies: [
        .package(name: "swift-log", url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(name: "grpc-swift", url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0-alpha.12"),
        .package(name: "Auth", url: "https://github.com/googleapis/google-auth-library-swift.git", from: "0.5.2"),
        .package(name: "vapor", url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "GoogleCloudLogging", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            .product(name: "GRPC", package: "grpc-swift"),
            .product(name: "OAuth2", package: "Auth"),
            .product(name: "Vapor", package: "vapor"),
        ]),
        .testTarget( name: "GoogleCloudLoggingTests", dependencies: ["GoogleCloudLogging"]),
    ]
)
