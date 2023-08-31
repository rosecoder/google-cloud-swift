import Foundation
import MySQLNIO
import NIO
import CloudCore

public actor MySQL: Dependency {

    public static var shared = MySQL()

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
        _connection = try MySQLConnection.connect(
            to: .makeAddressResolvingHost(ProcessInfo.processInfo.environment["MYSQL_HOST"] ?? "127.0.0.1", port: 3306),
            username: ProcessInfo.processInfo.environment["MYSQL_USER"] ?? "dev",
            database: ProcessInfo.processInfo.environment["MYSQL_DATABASE"] ?? "dev",
            password: ProcessInfo.processInfo.environment["MYSQL_PASSWORD"] ?? "dev",
            tlsConfiguration: nil,
            on: eventLoopGroup.next()
        )
    }

    // MARK: - Termination

    public func shutdown() async throws {
        try await _connection?.get().close().get()
    }
}
