import Foundation
import NIO
import GRPC
import GCPCore

public protocol GRPCDependency: Dependency {

    associatedtype Client

    static var serviceEnvironmentName: String { get }
    static var developmentPort: Int { get }

    static var _client: Client? { get }
    static func initClient(channel: GRPCChannel)
}

private enum GRPCDependencyBootstrapError: Error {
    case serviceHostNotFound
    case servicePortNotFound
    case invalidServicePort(String)
}

extension GRPCDependency where Client: GRPCClient {

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
        // Using kuberentes-standard of naming env vars: https://kubernetes.io/docs/concepts/services-networking/service/#environment-variables
        guard let host = ProcessInfo.processInfo.environment[serviceEnvironmentName + "_SERVICE_HOST"] else {
            throw GRPCDependencyBootstrapError.serviceHostNotFound
        }
        guard let rawPort = ProcessInfo.processInfo.environment[serviceEnvironmentName + "_SERVICE_PORT"] else {
            throw GRPCDependencyBootstrapError.servicePortNotFound
        }
        guard let port = Int(rawPort) else {
            throw GRPCDependencyBootstrapError.invalidServicePort(rawPort)
        }

        self.initClient(channel: ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: host, port: port)
        )
    }

#if DEBUG
    private static func bootstrapForDevelopment(eventLoopGroup: EventLoopGroup) async throws {
        self.initClient(channel: ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: "localhost", port: developmentPort)
        )
    }
#endif
}
