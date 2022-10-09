import Foundation
import MySQLNIO
import NIO
import GCPCore

public struct MySQL: Dependency {

    private static var _connection: EventLoopFuture<MySQLConnection>?

    static var connection: MySQLConnection {
        get async throws {
            guard let _connection = _connection else {
                fatalError("Must call MySQL.bootstrap(eventLoopGroup:) first")
            }

            return try await _connection.get()
        }
    }

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
    }

    static func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
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

    public static func shutdown() async throws {
        try await _connection?.get().close().get()
    }
}
