import CloudTrace
import RediStack

extension Redis {

    public static func delete(
        keys: [RedisKey],
        context: Context
    ) async throws {
        try await shared.ensureConnection(context: context)
        try await context.trace.recordSpan(named: "redis-del", kind: .client, attributes: [
            "redis/key": keys.map({ $0.rawValue }).joined(separator: ","),
        ]) { span in
            _ = try await shared.connection.delete(keys).get()
        }
    }

    public static func delete(
        key: RedisKey,
        context: Context
    ) async throws {
        try await delete(keys: [key], context: context)
    }
}
