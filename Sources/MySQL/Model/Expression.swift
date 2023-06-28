import MySQLNIO

public indirect enum Expression: Equatable {
    case property(PropertyReference, Operator)
    case and([Expression])
    case or([Expression])

    // MARK: - SQL

    func sql(binds: inout [MySQLData]) -> String {
        switch self {
        case .property(let property, let `operator`):
            return property.sql(binds: &binds) + " " + `operator`.sql(binds: &binds)
        case .and(let expressions):
            return expressions
                .map { $0.sql(binds: &binds) }
                .joined(separator: " AND ")
        case .or(let expressions):
            return expressions
                .map { $0.sql(binds: &binds) }
                .joined(separator: " OR ")
        }
    }
}

