import MySQLNIO

public enum Operator: Equatable {
    case equals(MySQLData)
    case lessThan(MySQLData)
    case lessThanOrEquals(MySQLData)
    case greaterThan(MySQLData)
    case greaterThanOrEquals(MySQLData)
    case `in`(SelectQuery)

    func sql(binds: inout [MySQLData]) -> String {
        switch self {
        case .equals(let data):
            binds.append(data)
            return "= ?"
        case .lessThan(let data):
            binds.append(data)
            return "< ?"
        case .lessThanOrEquals(let data):
            binds.append(data)
            return "<= ?"
        case .greaterThan(let data):
            binds.append(data)
            return "> ?"
        case .greaterThanOrEquals(let data):
            binds.append(data)
            return ">= ?"
        case .in(let query):
            return "IN (" + query.sql(binds: &binds) + ")"
        }
    }
}
