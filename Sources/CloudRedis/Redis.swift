import Foundation
import NIO
import RediStack
import CloudCore
import CloudTrace

public struct Redis: Dependency {

    public private(set) static var connection: RedisConnection!

    public static var defaultEncoder: Encoder = JSONEncoder()
    public static var defaultDecoder: Decoder = JSONDecoder()

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        try await createConnection()
    }

    private static func createConnection() async throws {
        guard let _unsafeInitializedEventLoopGroup else {
            return
        }

        connection = try await RedisConnection.make(
            configuration: try .init(
                hostname: ProcessInfo.processInfo.environment["REDIS_HOST"] ?? ProcessInfo.processInfo.environment["REDIS_SERVICE_HOST"] ?? "127.0.0.1"
            ),
            boundEventLoop: _unsafeInitializedEventLoopGroup.next()
        ).get()
    }

    static func ensureConnection(context: Context) async throws {
        if connection?.isConnected != true {
            try await context.trace.recordSpan(named: "redis-connect", kind: .client) { span in
                try await createConnection()
            }
        }
    }
}
