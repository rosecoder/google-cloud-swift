import NIO
import XCTest
@testable import CloudTranslation

class EmulatorTestCase: XCTestCase {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        try await Translation.bootstrap(eventLoopGroup: eventLoopGroup)
    }
}
