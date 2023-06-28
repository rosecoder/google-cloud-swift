import Foundation
import NIO
import RediStack
import Core

public struct Redis: Dependency {

    public private(set) static var connection: RedisConnection!

    public static var defaultEncoder: Encoder = JSONEncoder()
    public static var defaultDecoder: Decoder = JSONDecoder()

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        connection = try await RedisConnection.make(
            configuration: try .init(
                hostname: ProcessInfo.processInfo.environment["REDIS_HOST"] ?? ProcessInfo.processInfo.environment["REDIS_SERVICE_HOST"] ?? "127.0.0.1"
            ),
            boundEventLoop: eventLoopGroup.next()
        ).get()
    }
}
