import XCTest
@testable import CloudErrorReporting
import NIO

final class ReportTests: XCTestCase {

    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    func testReportError() async throws {
        try await ErrorReporting.shared.bootstrap(eventLoopGroup: eventLoopGroup)

        try await ErrorReporting.report(
            date: Date(),
            message: "Error doing testing",
            source: "error-reporting.test",
            file: #file,
            function: #function,
            line: #line
        )
    }
}
