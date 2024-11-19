import Tracing
@preconcurrency import RediStack

extension Redis {

    public enum Expiration: Hashable {
        case seconds(Int)
        case milliseconds(Int)
    }

    public func set<Value>(
        key: RedisKey,
        to value: Value,
        expiration: Expiration? = nil
    ) async throws
    where Value: Codable
    {
        let encoded = try defaultEncoder.encode(value)

        let connection = try await ensureConnection()
        try await withSpan("redis-set", ofKind: .client) { span in
            span.attributes["redis/key"] = key.rawValue
            switch expiration {
            case .none:
                _ = try await connection.set(key, to: encoded).get()
            case .seconds(let seconds):
                _ = try await connection.setex(key, to: encoded, expirationInSeconds: seconds).get()
            case .milliseconds(let milliseconds):
                _ = try await connection.psetex(key, to: encoded, expirationInMilliseconds: milliseconds).get()
            }
        }
    }

    public typealias ConditionalExpiration = RedisSetCommandExpiration
    public typealias ConditionalSetResult = RedisSetCommandResult

    public func set<Value>(
        key: RedisKey,
        to value: Value,
        condition: RedisSetCommandCondition,
        expiration: ConditionalExpiration? = nil
    ) async throws -> ConditionalSetResult
    where Value: Codable
    {
        let encoded = try defaultEncoder.encode(value)
        
        let connection = try await ensureConnection()
        return try await withSpan("redis-set", ofKind: .client) { span in
            span.attributes["redis/key"] = key.rawValue
            return try await connection.set(
                key,
                to: encoded,
                onCondition: condition,
                expiration: expiration
            ).get()
        }
    }
}
