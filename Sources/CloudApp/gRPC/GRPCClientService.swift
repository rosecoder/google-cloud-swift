import CloudCore
import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2Posix
import GRPCOTelTracingInterceptors
import NIO
import ServiceLifecycle

enum GRPCClientServiceError: Error {
    case serviceSchemeNotFound
    case unsupportedServiceScheme(String)
    case invalidServicePort(String)
}

public struct GRPCClientService: Service {

    public let client: GRPCClient<HTTP2ClientTransport.Posix>

    public init(client: GRPCClient<HTTP2ClientTransport.Posix>) {
        self.client = client
    }

    public init(serviceEnvironmentName: String, developmentPort: Int) throws {

        if let address = ProcessInfo.processInfo.environment[serviceEnvironmentName] {
            let (scheme, host, port) = try address.parsedAddressComponents()
            var interceptors: [any ClientInterceptor] = [
                ClientOTelTracingInterceptor(
                    serverHostname: host,
                    networkTransportMethod: "tcp"
                )
            ]
            switch scheme {
            case "https":
                if host.hasSuffix(".run.app") {
                    interceptors.append(CloudRunAuthenticateInterceptor(host: host))
                }
                self.init(
                    client: GRPCClient(
                        transport: try .http2NIOPosix(
                            target: .dns(host: host, port: port),
                            transportSecurity: .tls
                        ),
                        interceptors: interceptors
                    ))
            case "http":
                self.init(
                    client: GRPCClient(
                        transport: try .http2NIOPosix(
                            target: .dns(host: host, port: port),
                            transportSecurity: .tls
                        ),
                        interceptors: interceptors
                    ))
            default:
                throw GRPCClientServiceError.unsupportedServiceScheme(String(scheme))
            }
            return
        }

        // Using Kubernetes-standard of naming env vars: https://kubernetes.io/docs/concepts/services-networking/service/#environment-variables
        if let host = ProcessInfo.processInfo.environment[serviceEnvironmentName + "_SERVICE_HOST"],
            let rawPort = ProcessInfo.processInfo.environment[
                serviceEnvironmentName + "_SERVICE_PORT"],
            let port = Int(rawPort)
        {
            self.init(
                client: GRPCClient(
                    transport: try .http2NIOPosix(
                        target: .dns(host: host, port: port),
                        transportSecurity: .plaintext
                    ),
                    interceptors: [
                        ClientOTelTracingInterceptor(
                            serverHostname: host,
                            networkTransportMethod: "tcp"
                        )
                    ]
                ))
            return
        }

        // Fallback to localhost
        self.init(
            client: GRPCClient(
                transport: try .http2NIOPosix(
                    target: .dns(host: "localhost", port: developmentPort),
                    transportSecurity: .plaintext
                ),
                interceptors: [
                    ClientOTelTracingInterceptor(
                        serverHostname: "localhost",
                        networkTransportMethod: "tcp"
                    )
                ]
            ))
    }

    public func run() async throws {
        try await withGracefulShutdownHandler {
            try await withThrowingDiscardingTaskGroup { group in
                group.addTask {
                    try await client.runConnections()
                }
            }
        } onGracefulShutdown: {
            client.beginGracefulShutdown()
        }
    }
}

extension String {

    func parsedAddressComponents() throws -> (scheme: Substring, host: String, port: Int?) {
        guard let schemeEndRange = range(of: "://") else {
            throw GRPCClientServiceError.serviceSchemeNotFound
        }
        let scheme = self[..<schemeEndRange.lowerBound]

        let hostEndRange =
            range(of: ":", range: schemeEndRange.upperBound..<endIndex) ?? endIndex..<endIndex
        let host = String(self[schemeEndRange.upperBound..<hostEndRange.lowerBound])

        let port: Int?
        if hostEndRange.isEmpty {
            port = nil
        } else {
            let portString = self[hostEndRange.upperBound...]
            guard let portFromAddress = Int(portString) else {
                throw GRPCClientServiceError.invalidServicePort(String(portString))
            }
            port = portFromAddress
        }
        return (scheme, host, port)
    }
}
