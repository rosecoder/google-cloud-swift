import MySQLNIO

public struct SelectQuery: Equatable {

    public var properties: [PropertyReference]
    public var table: Table
    public var whereExpression: Expression?
    public var grouped: [PropertyReference]
    public var havingExpression: Expression?
    public var orders: [Ordering]

    public init(
        _ properties: [PropertyReference],
        from table: Table,
        where whereExpression: Expression? = nil,
        groupBy grouped: [PropertyReference] = [],
        having havingExpression: Expression? = nil,
        orderBy orders: [Ordering] = []
    ) {
        self.properties = properties
        self.table = table
        self.whereExpression = whereExpression
        self.grouped = grouped
        self.havingExpression = havingExpression
        self.orders = orders
    }

    public init(
        _ property: PropertyReference,
        from table: Table,
        where whereExpression: Expression? = nil,
        groupBy grouped: [PropertyReference] = [],
        having havingExpression: Expression? = nil,
        orderBy orders: [Ordering] = []
    ) {
        self.properties = [property]
        self.table = table
        self.whereExpression = whereExpression
        self.grouped = grouped
        self.havingExpression = havingExpression
        self.orders = orders
    }

    // MARK: - SQL

    func sql(binds: inout [MySQLData]) -> String {
        var query = "SELECT "

        query += properties
            .map { $0.sql(binds: &binds) }
            .joined(separator: ",")

        query += " FROM " + table.sql()

        if let whereExpression {
            query += " WHERE " + whereExpression.sql(binds: &binds)
        }
        if !grouped.isEmpty {
            query += " GROUP BY " + grouped
                .map { $0.sql(binds: &binds) }
                .joined(separator: ",")

            if let havingExpression {
                query += " HAVING " + havingExpression.sql(binds: &binds)
            }
        }
        if !orders.isEmpty {
            query += " ORDER BY " + orders
                .map { $0.sql(binds: &binds) }
                .joined(separator: ",")
        }

        return query
    }

    func sql() -> SQL {
        var binds = [MySQLData]()
        let query = sql(binds: &binds)
        return SQL(unsafeQuery: query, binds: binds)
    }
}
