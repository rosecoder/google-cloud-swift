import Foundation
import NIO
@preconcurrency import RediStack
import CloudCore
import CloudTrace

public actor Redis: Dependency {

    public static let shared = Redis()

    public private(set) var connection: RedisConnection!

    public static var defaultEncoder: Encoder = JSONEncoder()
    public static var defaultDecoder: Decoder = JSONDecoder()

    // MARK: - Bootstrap

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        try await createConnection(eventLoopGroup: eventLoopGroup)
    }

    private func createConnection(eventLoopGroup: EventLoopGroup) async throws {
        connection = try await RedisConnection.make(
            configuration: try .init(
                hostname: ProcessInfo.processInfo.environment["REDIS_HOST"] ?? ProcessInfo.processInfo.environment["REDIS_SERVICE_HOST"] ?? "127.0.0.1"
            ),
            boundEventLoop: eventLoopGroup.next()
        ).get()
    }

    func ensureConnection(context: Context) async throws {
        if connection?.isConnected != true, let eventLoopGroup = _unsafeInitializedEventLoopGroup {
            try await context.trace.recordSpan(named: "redis-connect", kind: .client) { span in
                try await Redis.shared.createConnection(eventLoopGroup: eventLoopGroup)
            }
        }
    }
}
