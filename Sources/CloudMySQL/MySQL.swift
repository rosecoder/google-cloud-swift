import Foundation
@preconcurrency import MySQLNIO
import NIO
import CloudCore

public actor MySQL: Dependency {

    public static let shared = MySQL()

    private var _connection: EventLoopFuture<MySQLConnection>?

    var connection: MySQLConnection {
        get async throws {
            if _connection == nil {
                try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
            }
            return try await _connection!.get()
        }
    }

    // MARK: - Bootstrap

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
    }

    func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        if let unixSocketPath = ProcessInfo.processInfo.environment["MYSQL_UNIX_SOCKET"] ?? ProcessInfo.processInfo.environment["INSTANCE_UNIX_SOCKET"] {
            _connection = try MySQLConnection.connect(
                to: .init(unixDomainSocketPath: unixSocketPath),
                username: ProcessInfo.processInfo.environment["MYSQL_USER"] ?? ProcessInfo.processInfo.environment["DB_USER"] ?? "dev",
                database: ProcessInfo.processInfo.environment["MYSQL_DATABASE"] ?? ProcessInfo.processInfo.environment["DB_NAME"] ?? "dev",
                password: ProcessInfo.processInfo.environment["MYSQL_PASSWORD"] ?? ProcessInfo.processInfo.environment["DB_PASS"] ?? "dev",
                tlsConfiguration: nil,
                on: eventLoopGroup.next()
            )
            return
        }
        _connection = try MySQLConnection.connect(
            to: .makeAddressResolvingHost(ProcessInfo.processInfo.environment["MYSQL_HOST"] ?? ProcessInfo.processInfo.environment["INSTANCE_CONNECTION_NAME"] ?? "127.0.0.1", port: 3306),
            username: ProcessInfo.processInfo.environment["MYSQL_USER"] ?? ProcessInfo.processInfo.environment["DB_USER"] ?? "dev",
            database: ProcessInfo.processInfo.environment["MYSQL_DATABASE"] ?? ProcessInfo.processInfo.environment["DB_NAME"] ?? "dev",
            password: ProcessInfo.processInfo.environment["MYSQL_PASSWORD"] ?? ProcessInfo.processInfo.environment["DB_PASS"] ?? "dev",
            tlsConfiguration: nil,
            on: eventLoopGroup.next()
        )
    }

    // MARK: - Termination

    public func shutdown() async throws {
        try await _connection?.get().close().get()
    }
}
