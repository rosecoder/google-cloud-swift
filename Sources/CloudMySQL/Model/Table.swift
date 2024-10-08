import MySQLNIO

public struct Table: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible, Sendable {

    public let rawValue: String
    public let database: Database?

    public init(rawValue: String, database: Database? = nil) {
        self.rawValue = rawValue
        self.database = database
    }

    // MARK: - SQL

    func sql() -> String {
        if let database {
            return database.sql() + ".`" + rawValue + "`"
        }
        return "`" + rawValue + "`"
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        if let database {
            return database.description + "." + rawValue
        }
        return rawValue
    }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String {
        if let database {
            return database.debugDescription + ".`" + rawValue + "`"
        }
        return "`" + rawValue + "`"
    }
}
