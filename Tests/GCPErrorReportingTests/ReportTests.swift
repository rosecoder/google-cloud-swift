import XCTest
@testable import GCPErrorReporting
import NIO

final class ReportTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    func testReportError() async throws {
        ErrorReporting.bootstrap(
            eventLoopGroup: eventLoopGroup,
            resource: .k8sContainer(
                projectID: "nightshift-habits-poc",
                location: "europe-west3-b",
                clusterName: "kubernetes",
                namespaceName: "default",
                podName: "swift-test-1234",
                containerName: "swift-test"
            )
        )

        struct TestError: Error {}

        try await ErrorReporting.report(
            date: Date(),
            error: TestError(),
            source: "error-reporting.test",
            file: #file,
            function: #function,
            line: #line
        )
    }
}
