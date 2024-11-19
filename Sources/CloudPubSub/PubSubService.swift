import Foundation
import CloudCore
import GoogleCloudAuth
import Synchronization
import ServiceLifecycle
import GRPCCore

public final class PubSubService: Service {

    private let authorization: Authorization?
    let grpcClient: GRPCClient

    public init() throws {
        if let host = ProcessInfo.processInfo.environment["PUBSUB_EMULATOR_HOST"] {
            let components = host.components(separatedBy: ":")
            let port = Int(components[1])!

            self.authorization = nil
            self.grpcClient = GRPCClient(
                transport: try .http2NIOPosix(
                    target: .dns(host: components[0], port: port),
                    config: .defaults(transportSecurity: .plaintext)
                )
            )
        } else {
            let authorization = Authorization(scopes: [
                "https://www.googleapis.com/auth/cloud-platform",
                "https://www.googleapis.com/auth/pubsub",
            ], eventLoopGroup: .singletonMultiThreadedEventLoopGroup)

            self.authorization = authorization
            self.grpcClient = GRPCClient(
                transport: try .http2NIOPosix(
                    target: .dns(host: "pubsub.googleapis.com", port: 443),
                    config: .defaults(transportSecurity: .tls(.defaults(configure: { config in
                        config.serverHostname = "pubsub.googleapis.com" as String?
                    })))
                ),
                interceptors: [
                    AuthorizationClientInterceptor(authorization: authorization),
                ]
            )
        }
    }

    public func run() async throws {
        try await withGracefulShutdownHandler {
            try await grpcClient.run()
        } onGracefulShutdown: {
            self.grpcClient.beginGracefulShutdown()
        }

        try await authorization?.shutdown()
    }

    // MARK: - Create if needed

    private let verifiedHashValues = Mutex<[Int]>([])

    func createIfNeeded(
        hashValue: Int,
        creation: @Sendable () async throws -> Void
    ) async throws {
        let shouldCreate = verifiedHashValues.withLock {
            guard !$0.contains(hashValue) else {
                return false
            }
            $0.append(hashValue)
            return true
        }
        if shouldCreate {
            try await creation()
        }
    }
}
