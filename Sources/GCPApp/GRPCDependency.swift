import Foundation
import NIO
import GRPC
import GCPCore

public protocol GRPCDependency: Dependency {

    associatedtype Client

    static var hostEnvironmentName: String { get }
    static var developmentPort: Int { get }

    static var _client: Client? { get }
    static func initClient(channel: GRPCChannel)
}

private enum APIBootstrapError: Error {
    case hostNotConfigured
}

extension GRPCDependency where Client: GRPCClient {

#if DEBUG
    public static var port: Int { developmentPort }
#else
    public static var port: Int { 80 }
#endif

    public static var client: Client {
        guard let _client = _client else {
            fatalError("\(self) has not been bootstrapped yet.")
        }
        return _client
    }

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        try await bootstrapForDevelopment(eventLoopGroup: eventLoopGroup)
#else
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
#endif
    }

    private static func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        guard let host = ProcessInfo.processInfo.environment[hostEnvironmentName] else {
            throw APIBootstrapError.hostNotConfigured
        }

        self.initClient(channel: ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: host, port: port)
        )
    }

#if DEBUG
    private static func bootstrapForDevelopment(eventLoopGroup: EventLoopGroup) async throws {
        let host = ProcessInfo.processInfo.environment[hostEnvironmentName] ?? "localhost"
        self.initClient(channel: ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: host, port: port)
        )
    }
#endif
}
