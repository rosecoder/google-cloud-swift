import CloudCore
import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2Posix
import GoogleCloudAuth
import GoogleCloudAuthGRPC
import GoogleCloudServiceContext
import ServiceContextModule
import ServiceLifecycle

public actor AIPlatform: Service {

    private let authorization: Authorization
    private let grpcClient: GRPCClient<HTTP2ClientTransport.Posix>
    public let client: Google_Cloud_Aiplatform_V1_PredictionService.ClientProtocol

    public enum ConfigurationError: Error {
        case missingProjectID
        case missingLocationID
    }

    public let projectID: String
    public let locationID: String

    public init() async throws {
        guard let projectID = await (ServiceContext.current ?? .topLevel).projectID else {
            throw ConfigurationError.missingProjectID
        }
        guard let locationID = await (ServiceContext.current ?? .topLevel).locationID else {
            throw ConfigurationError.missingLocationID
        }
        self.projectID = projectID
        self.locationID = locationID

        self.authorization = Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-platform"],
            eventLoopGroup: .singletonMultiThreadedEventLoopGroup
        )
        self.grpcClient = GRPCClient(
            transport: try .http2NIOPosix(
                target: .dns(host: locationID + "-aiplatform.googleapis.com"),
                transportSecurity: .tls,
                config: .defaults { config in
                    config.backoff = .init(
                        initial: .milliseconds(100),
                        max: .seconds(1),
                        multiplier: 1.6,
                        jitter: 0.2
                    )
                    config.connection = .init(
                        maxIdleTime: .seconds(30 * 60),
                        keepalive: .init(
                            time: .seconds(30),
                            timeout: .seconds(5),
                            allowWithoutCalls: true
                        )
                    )
                },
                serviceConfig: .init(
                    methodConfig: [
                        .init(
                            names: [.init(service: "")],  // Empty service means all methods
                            waitForReady: true,
                            timeout: .seconds(60)
                        )
                    ]
                )
            ),
            interceptors: [
                AuthorizationClientInterceptor(authorization: authorization)
            ]
        )
        self.client = Google_Cloud_Aiplatform_V1_PredictionService.Client(wrapping: grpcClient)
    }

    public func run() async throws {
        try await withGracefulShutdownHandler {
            try await grpcClient.runConnections()
        } onGracefulShutdown: {
            self.grpcClient.beginGracefulShutdown()
        }

        try await authorization.shutdown()
    }
}
