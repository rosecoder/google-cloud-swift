import Foundation
import NIO
@preconcurrency import RediStack
import CloudCore
import Logging
import Tracing
import ServiceLifecycle

public actor Redis: Service {

    private var _connection: RedisConnection?

    public var defaultEncoder: Encoder = JSONEncoder()
    public var defaultDecoder: Decoder = JSONDecoder()

    let logger = Logger(label: "redis")

    public init() {}

    public func run() async throws {
        let foreverTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(.infinity))
            }
        }
        await withGracefulShutdownHandler {
            await foreverTask.value
        } onGracefulShutdown: {
            foreverTask.cancel()
        }

        try await _connection?.close().get()
    }

    public func ensureConnection() async throws -> RedisConnection {
        if let _connection, _connection.isConnected {
            return _connection
        }
        return try await withSpan("redis-connect", ofKind: .client) { span in
            let connection = try await RedisConnection.make(
                configuration: try .init(
                    hostname: ProcessInfo.processInfo.environment["REDIS_HOST"] ?? ProcessInfo.processInfo.environment["REDIS_SERVICE_HOST"] ?? "127.0.0.1"
                ),
                boundEventLoop: MultiThreadedEventLoopGroup.singletonMultiThreadedEventLoopGroup.next()
            ).get()
            self._connection = connection
            return connection
        }
    }
}
