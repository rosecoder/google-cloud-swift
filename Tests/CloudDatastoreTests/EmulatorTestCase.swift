import NIO
import Foundation
import XCTest
@testable import CloudDatastore

class EmulatorTestCase: XCTestCase {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        await Datastore.shared.bootstraForEmulator(host: "localhost", port: 8081, eventLoopGroup: eventLoopGroup)
    }

    override func tearDown() async throws {
        try await Datastore.deleteEntities(query: Query(User.self), context: context)

        // Wait for emulated datastore to complete it's writes
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms

        try await super.tearDown()
    }
}
