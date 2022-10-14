import MySQLNIO

public indirect enum PropertyReference: ExpressibleByStringLiteral, Equatable {
    case wildcard
    case named(String)
    case distinct(PropertyReference)
    case count(PropertyReference)
    case inString(string: PropertyReference, substring: PropertyReference)

    public typealias StringLiteralType = StaticString

    public init(stringLiteral value: StaticString) {
        let string = value.description
        switch string {
        case "*":
            self = .wildcard
        default:
            self = .named(string)
        }
    }

    // MARK: - SQL

    func sql(binds: inout [MySQLData]) -> String {
        switch self {
        case .named(let name):
            return "`" + name.description + "`"
        case .distinct(let property):
            return "DISTINCT " + property.sql(binds: &binds)
        case .wildcard:
            return "*"
        case .count(let property):
            return "COUNT(" + property.sql(binds: &binds) + ")"
        case .inString(let string, let substring):
            return "INSTR(" + string.sql(binds: &binds) + "," + substring.sql(binds: &binds) + ")"
        }
    }
}
