import CloudTrace
import RediStack

extension Redis {

    public enum Expiration: Hashable {
        case seconds(Int)
        case milliseconds(Int)
    }

    public static func set<Value>(
        key: RedisKey,
        to value: Value,
        expiration: Expiration? = nil,
        context: Context
    ) async throws
    where Value: Codable
    {
        let encoded = try defaultEncoder.encode(value)

        try await shared.ensureConnection(context: context)
        try await context.trace.recordSpan(named: "redis-set", kind: .client, attributes: [
            "redis/key": key.rawValue,
        ]) { span in
            switch expiration {
            case .none:
                _ = try await shared.connection.set(key, to: encoded).get()
            case .seconds(let seconds):
                _ = try await shared.connection.setex(key, to: encoded, expirationInSeconds: seconds).get()
            case .milliseconds(let milliseconds):
                _ = try await shared.connection.psetex(key, to: encoded, expirationInMilliseconds: milliseconds).get()
            }
        }
    }

    public typealias ConditionalExpiration = RedisSetCommandExpiration
    public typealias ConditionalSetResult = RedisSetCommandResult

    public static func set<Value>(
        key: RedisKey,
        to value: Value,
        condition: RedisSetCommandCondition,
        expiration: ConditionalExpiration? = nil,
        context: Context
    ) async throws -> ConditionalSetResult
    where Value: Codable
    {
        let encoded = try defaultEncoder.encode(value)
        
        try await shared.ensureConnection(context: context)
        return try await context.trace.recordSpan(named: "redis-set", kind: .client, attributes: [
            "redis/key": key.rawValue,
        ]) { span in
            try await shared.connection.set(
                key,
                to: encoded,
                onCondition: condition,
                expiration: expiration
            ).get()
        }
    }
}
