import XCTest
import GCPMySQL
import GCPTrace
import NIO

final class QueryTests: XCTestCase {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    override func setUp() async throws {
        try await super.setUp()

        try await MySQL.bootstrap(eventLoopGroup: eventLoopGroup)
    }

    // MARK: - Get

    func testOperations() async throws {
        _ = try await MySQL.queryWithMetadata("DELETE FROM dev.Test", context: context)

        let (_, insertMetadata) = try await MySQL.queryWithMetadata("INSERT INTO dev.Test (ID, Name) VALUES (1, \("Gustaf"))", context: context)
        XCTAssertEqual(insertMetadata.affectedRows, 1)

        let rows = try await MySQL.query("SELECT ID, Name FROM dev.Test", context: context)
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows.first?.column("ID")?.int, 1)
        XCTAssertEqual(rows.first?.column("Name")?.string, "Gustaf")
    }
}
