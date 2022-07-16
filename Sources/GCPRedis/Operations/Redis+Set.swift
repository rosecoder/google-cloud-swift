import GCPTrace
import RediStack

extension Redis {

    public static func set<Value>(
        key: RedisKey,
        to value: Value,
        trace: Trace?
    ) async throws
    where Value: Codable
    {
        let encoded = try defaultEncoder.encode(value)

        try await trace.recordSpan(named: "redis-set", attributes: [
            "redis/key": key.rawValue,
        ]) { span in
            _ = try await connection.set(key, to: encoded).get()
        }
    }
}
