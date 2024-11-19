import Tracing
@preconcurrency import RediStack

extension Redis {

    public func delete(keys: [RedisKey]) async throws {
        let connection = try await ensureConnection()
        try await withSpan("redis-del", ofKind: .client) { span in
            span.attributes["redis/key"] = keys.map({ $0.rawValue }).joined(separator: ",")
            _ = try await connection.delete(keys).get()
        }
    }

    public func delete(key: RedisKey) async throws {
        try await delete(keys: [key])
    }
}
