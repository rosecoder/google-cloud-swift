import XCTest
import MySQLNIO
@testable import CloudMySQL

final class SQLTests: XCTestCase {

    func testSQLExpressibleByStaticString() async throws {
        let sql: SQL = "SELECT `id` FROM Test WHERE `id` = \(1) LIMIT 1"
        XCTAssertEqual(sql.query, "SELECT `id` FROM Test WHERE `id` = ? LIMIT 1")
        XCTAssertEqual(sql.binds.count, 1)
        XCTAssertEqual(sql.binds.first?.int, 1)
    }
}
