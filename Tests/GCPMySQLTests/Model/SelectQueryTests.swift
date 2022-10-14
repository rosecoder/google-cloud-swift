import XCTest
import MySQLNIO
@testable import GCPMySQL

extension Table {

    fileprivate static let test = Table(rawValue: "Test")
    fileprivate static let test2 = Table(rawValue: "Test2")

    fileprivate static let testWithDatabase = Table(rawValue: "Test", database: Database(rawValue: "Testing"))
}

final class SelectQueryTests: XCTestCase {

    func testWithDatabaseSpecified() async throws {
        XCTAssertEqual(
            SelectQuery("id", from: .testWithDatabase).sql(),
            "SELECT `id` FROM `Testing`.`Test`"
        )
    }

    // MARK: - Properties

    func testWithProperty() async throws {
        XCTAssertEqual(
            SelectQuery("id", from: .test).sql(),
            "SELECT `id` FROM `Test`"
        )
        XCTAssertEqual(
            SelectQuery(.named("id"), from: .test).sql(),
            "SELECT `id` FROM `Test`"
        )
    }

    func testWithPropertyDistinct() async throws {
        XCTAssertEqual(
            SelectQuery(.distinct("id"), from: .test).sql(),
            "SELECT DISTINCT `id` FROM `Test`"
        )
    }

    func testWithMultipleProperty() async throws {
        XCTAssertEqual(
            SelectQuery(["id", "name"], from: .test).sql(),
            "SELECT `id`,`name` FROM `Test`"
        )
        XCTAssertEqual(
            SelectQuery([.named("id"), .named("name")], from: .test).sql(),
            "SELECT `id`,`name` FROM `Test`"
        )
    }

    func testWithWildcard() async throws {
        XCTAssertEqual(
            SelectQuery(.wildcard, from: .test).sql(),
            "SELECT * FROM `Test`"
        )
        XCTAssertEqual(
            SelectQuery("*", from: .test).sql(),
            "SELECT * FROM `Test`"
        )
    }

    func testWithCount() async throws {
        XCTAssertEqual(
            SelectQuery(.count("*"), from: .test).sql(),
            "SELECT COUNT(*) FROM `Test`"
        )
        XCTAssertEqual(
            SelectQuery(.count("id"), from: .test).sql(),
            "SELECT COUNT(`id`) FROM `Test`"
        )
    }

    // MARK: - Where

    func testWithWhereEquals() async throws {
        let sql = SelectQuery("id", from: .test, where: .property("id", .equals(1))).sql()
        XCTAssertEqual(sql.query, "SELECT `id` FROM `Test` WHERE `id` = ?")
        XCTAssertEqual(sql.binds, [1])
    }

    func testWithWhereLessThan() async throws {
        let sql = SelectQuery("id", from: .test, where: .property("id", .lessThan(1))).sql()
        XCTAssertEqual(sql.query, "SELECT `id` FROM `Test` WHERE `id` < ?")
        XCTAssertEqual(sql.binds, [1])
    }

    func testWithWhereIn() async throws {
        let sql = SelectQuery("id", from: .test, where: .property("id", .in(SelectQuery("id", from: .test2)))).sql()
        XCTAssertEqual(sql.query, "SELECT `id` FROM `Test` WHERE `id` IN (SELECT `id` FROM `Test2`)")
        XCTAssertEqual(sql.binds, [])
    }

    func testWithMultipleWhereExpressions() async throws {
        let sql = SelectQuery("id", from: .test, where: .and([.property("id", .equals(1)), .property("name", .equals("Gustaf"))])).sql()
        XCTAssertEqual(sql.query, "SELECT `id` FROM `Test` WHERE `id` = ? AND `name` = ?")
        XCTAssertEqual(sql.binds, [1, "Gustaf"])
    }

    // MARK: - Order

    func testWithOrder() async throws {
        let sql = SelectQuery("id", from: .test, orderBy: [.init(property: "name")]).sql()
        XCTAssertEqual(sql.query, "SELECT `id` FROM `Test` ORDER BY `name`")
        XCTAssertEqual(sql.binds, [])
    }

    func testWithOrderDescending() async throws {
        let sql = SelectQuery("id", from: .test, orderBy: [.init(property: "name", order: .descending)]).sql()
        XCTAssertEqual(sql.query, "SELECT `id` FROM `Test` ORDER BY `name` DESC")
        XCTAssertEqual(sql.binds, [])
    }
}
