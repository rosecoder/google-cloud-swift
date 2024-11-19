import RediStack

public typealias Key = RedisKey

extension RedisKey: @retroactive @unchecked Sendable {}
