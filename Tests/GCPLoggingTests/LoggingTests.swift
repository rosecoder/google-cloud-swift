import XCTest
@testable import GCPLogging
@testable import Logging
import NIO

final class GoogleCloudLoggingTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func tearDown() async throws {
        try eventLoopGroup.syncShutdownGracefully()

        try await super.tearDown()
    }

    func testLog() async throws {
        try GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)

        LoggingSystem.bootstrapInternal { label -> LogHandler in
            GoogleCloudLogHandler(label: label, resource: .k8sContainer(projectID: "ccode-development", location: "europe-west3-a", clusterName: "kubernetes", namespaceName: "default", podName: "admin-api-7764db5f79-6p4zs", containerName: "admin-api"))
        }

        // Create logger and log entry
        let logger = Logger(label: "test")
        logger.info("Hello world")

        // Wait for logging to complete
        let task = try XCTUnwrap(GoogleCloudLogHandler.lastLogTask)
        try await task.value
    }
}
