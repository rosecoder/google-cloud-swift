import Trace
import MySQLNIO

extension MySQL {

    public static func select(
        query: SelectQuery,
        context: Context
    ) async throws -> [MySQLRow] {
        try await self.query(query.sql(), context: context)
    }
}
