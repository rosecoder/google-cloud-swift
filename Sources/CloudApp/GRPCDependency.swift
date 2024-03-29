import Foundation
import NIO
import GRPC
import CloudCore

public protocol GRPCDependency: Dependency {

    associatedtype Client

    static var serviceEnvironmentName: String { get }
    static var developmentPort: Int { get }

    var _client: Client? { get }
    func initClient(channel: GRPCChannel)
}

enum GRPCDependencyBootstrapError: Error {
    case serviceSchemeNotFound
    case unsupportedServiceScheme(String)
    case serviceHostNotFound
    case servicePortNotFound
    case invalidServicePort(String)
}

extension GRPCDependency where Client: GRPCClient {

    public static var client: Client {
        get async throws {
            try await shared.client
        }
    }

    public var client: Client {
        get async throws {
            if _client == nil {
                try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
            }
            return _client!
        }
    }

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        try await bootstrapForDevelopment(eventLoopGroup: eventLoopGroup)
#else
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
#endif
    }

    private func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {

        // Try to connect via address
        if let address = ProcessInfo.processInfo.environment[Self.serviceEnvironmentName] {
            let (scheme, host, port) = try address.parsedAddressComponents()

            switch scheme {
            case "https":
                self.initClient(channel: ClientConnection
                    .usingTLSBackedByNIOSSL(on: eventLoopGroup)
                    .connect(host: host, port: port ?? 443)
                )
            case "http":
                self.initClient(channel: ClientConnection
                    .insecure(group: eventLoopGroup)
                    .connect(host: host, port: port ?? 80)
                )
            default:
                throw GRPCDependencyBootstrapError.unsupportedServiceScheme(String(scheme))
            }
            return
        }

        // Using kuberentes-standard of naming env vars: https://kubernetes.io/docs/concepts/services-networking/service/#environment-variables
        guard let host = ProcessInfo.processInfo.environment[Self.serviceEnvironmentName + "_SERVICE_HOST"] else {
            throw GRPCDependencyBootstrapError.serviceHostNotFound
        }
        guard let rawPort = ProcessInfo.processInfo.environment[Self.serviceEnvironmentName + "_SERVICE_PORT"] else {
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
    private func bootstrapForDevelopment(eventLoopGroup: EventLoopGroup) async throws {
        self.initClient(channel: ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: "localhost", port: Self.developmentPort)
        )
    }
#endif
}

extension String {

    func parsedAddressComponents() throws -> (scheme: Substring, host: String, port: Int?) {
        guard let schemeEndRange = range(of: "://") else {
            throw GRPCDependencyBootstrapError.serviceSchemeNotFound
        }
        let scheme = self[..<schemeEndRange.lowerBound]

        let hostEndRange = range(of: ":", range: schemeEndRange.upperBound..<endIndex) ?? endIndex..<endIndex
        let host = String(self[schemeEndRange.upperBound..<hostEndRange.lowerBound])

        let port: Int?
        if hostEndRange.isEmpty {
            port = nil
        } else {
            let portString = self[hostEndRange.upperBound...]
            guard let portFromAddress = Int(portString) else {
                throw GRPCDependencyBootstrapError.invalidServicePort(String(portString))
            }
            port = portFromAddress
        }
        return (scheme, host, port)
    }
}
