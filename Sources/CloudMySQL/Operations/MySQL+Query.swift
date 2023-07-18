import CloudTrace
import MySQLNIO

extension MySQL {

    public static func queryWithMetadata(
        _ sql: SQL,
        context: Context
    ) async throws -> (rows: [MySQLRow], metadata: MySQLQueryMetadata) {
        try await context.trace.recordSpan(named: "mysql-query", kind: .client, attributes: [
            "query": sql.query,
        ]) { span in
            let connection = try await self.connection
            let metadataPromise = connection.eventLoop.makePromise(of: MySQLQueryMetadata.self)
            let rowsFuture = connection.query(sql.query, sql.binds, onMetadata: {
                metadataPromise.succeed($0)
            })
            return try await rowsFuture.and(metadataPromise.futureResult).get()
        }
    }

    public static func query(
        _ sql: SQL,
        context: Context
    ) async throws -> [MySQLRow] {
        try await context.trace.recordSpan(named: "mysql-query", kind: .client, attributes: [
            "query": sql.query,
        ]) { span in
            let connection = try await self.connection
            return try await connection.query(sql.query, sql.binds).get()
        }
    }
}
