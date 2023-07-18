import NIO
import Foundation
import XCTest
@testable import CloudRedis

class EmulatorTestCase: XCTestCase {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        // TODO: Bootstrap with emulator

        try await Redis.bootstrap(eventLoopGroup: eventLoopGroup)
    }
}
