import NIO
import Foundation
import XCTest
@testable import GCPDatastore

class EmulatorTestCase: XCTestCase {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        Datastore.defaultProjectID = "testing"
        Datastore.bootstraForEmulator(host: "localhost:8081", eventLoopGroup: eventLoopGroup)
    }

    override func tearDown() async throws {
        try await Datastore.deleteEntities(query: Query(User.self))

        // Wait for emulated datastore to complete it's writes
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms

        try await super.tearDown()
    }
}
