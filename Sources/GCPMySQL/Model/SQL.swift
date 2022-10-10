import Foundation
import MySQLNIO

public struct SQL: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {

    public typealias StringLiteralType = StaticString

    public struct StringInterpolation: StringInterpolationProtocol {

        var output = ""
        var binds = [MySQLData]()

        public init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity + interpolationCount * 1)
            binds.reserveCapacity(interpolationCount)
        }

        public mutating func appendLiteral(_ literal: StaticString) {
            output.append(literal.description)
        }

        public mutating func appendInterpolation(_ data: MySQLData) {
            output.append("?")
            binds.append(data)
        }

        public mutating func appendInterpolation(_ database: Database) {
            output.append(database.sql())
        }

        public mutating func appendInterpolation(_ table: Table) {
            output.append(table.sql())
        }
    }

    let query: String
    let binds: [MySQLData]

    public init(unsafeQuery query: String, binds: [MySQLData] = []) {
        self.query = query
        self.binds = binds
    }

    public init(query: StaticString, binds: [MySQLData] = []) {
        self.query = query.description
        self.binds = binds
    }

    public init(stringLiteral value: StaticString) {
        self.query = value.description
        self.binds = []
    }

    public init(stringInterpolation: StringInterpolation) {
        self.query = stringInterpolation.output
        self.binds = stringInterpolation.binds
    }
}
