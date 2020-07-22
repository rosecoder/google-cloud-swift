import XCTest
@testable import GoogleCloudLogging
import Logging
import NIO

final class GoogleCloudLoggingTests: XCTestCase {

    static var allTests = [
        ("testLog", testLog),
    ]

    func testLog() throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        try GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)

        LoggingSystem.bootstrap { label -> LogHandler in
            GoogleCloudLogHandler(label: label, resource: .k8sContainer(projectID: "cfeedback-cloud", location: "europe-west3-a", clusterName: "kubernetes", namespaceName: "default", podName: "admin-api-7764db5f79-6p4zs", containerName: "admin-api"))
        }

        let logger = Logger(label: "test")
        logger.info("Hello world")

        sleep(5)
        try eventLoopGroup.syncShutdownGracefully()
    }
}
