import CloudTrace
import RediStack

extension Redis {

    public static func set<Value>(
        key: RedisKey,
        to value: Value,
        context: Context
    ) async throws
    where Value: Codable
    {
        let encoded = try defaultEncoder.encode(value)
        
        try await shared.ensureConnection(context: context)
        try await context.trace.recordSpan(named: "redis-set", kind: .client, attributes: [
            "redis/key": key.rawValue,
        ]) { span in
            _ = try await shared.connection.set(key, to: encoded).get()
        }
    }
}
