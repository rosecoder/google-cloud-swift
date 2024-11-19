import XCTest
import CloudMySQL
import NIO

final class QueryTests: XCTestCase {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        try await MySQL.shared.bootstrap(eventLoopGroup: eventLoopGroup)
    }

    // MARK: -

    func testOperations() async throws {
        _ = try await MySQL.queryWithMetadata("DELETE FROM dev.Test")

        let (_, insertMetadata) = try await MySQL.queryWithMetadata("INSERT INTO dev.Test (ID, Name) VALUES (1, \("Gustaf"))")
        XCTAssertEqual(insertMetadata.affectedRows, 1)

        let rows = try await MySQL.query("SELECT ID, Name FROM dev.Test")
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows.first?.column("ID")?.int, 1)
        XCTAssertEqual(rows.first?.column("Name")?.string, "Gustaf")
    }
}
