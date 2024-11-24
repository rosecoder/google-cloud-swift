import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2Posix
import CloudCore
import GoogleCloudAuth
import ServiceContextModule
import GoogleCloudServiceContext
import ServiceLifecycle

public actor AIPlatform: Service {

    private let authorization: Authorization
    private let grpcClient: GRPCClient
    public let client: Google_Cloud_Aiplatform_V1_PredictionService_ClientProtocol

    public init() throws {
        self.authorization = Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-platform"],
            eventLoopGroup: .singletonMultiThreadedEventLoopGroup
        )
        self.grpcClient = GRPCClient(
            transport: try .http2NIOPosix(
                target: .dns(host: "aiplatform.googleapis.com", port: 443),
                config: .defaults(transportSecurity: .tls(.defaults(configure: { config in
                    config.serverHostname = "aiplatform.googleapis.com" as String?
                })))
            ),
            interceptors: [
                AuthorizationClientInterceptor(authorization: authorization),
            ]
        )
        self.client = Google_Cloud_Aiplatform_V1_PredictionService_Client(wrapping: grpcClient)
    }

    public func run() async throws {
        try await withGracefulShutdownHandler {
            try await grpcClient.run()
        } onGracefulShutdown: {
            self.grpcClient.beginGracefulShutdown()
        }

        try await authorization.shutdown()
    }
}
