import Foundation
import GRPC
import NIO
import CloudCore
import CloudTrace
import GoogleCloudAuth

public actor AIPlatform: Dependency {

    public static var shared = AIPlatform()

    private var _client: Google_Cloud_Aiplatform_V1_PredictionServiceAsyncClient?

    public func client(context: Context) async throws -> Google_Cloud_Aiplatform_V1_PredictionServiceAsyncClient {
        if _client == nil {
            try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
        }
        var _client = _client!
        try await _client.ensureAuthentication(authorization: authorization, context: context, traceContext: "datastore")
        self._client = _client
        return _client
    }

    var authorization: Authorization?

    // MARK: - Bootstrap

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        try await bootstrapForDebug(eventLoopGroup: eventLoopGroup)
#else
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
#endif
        let locationID = await Environment.current.locationID
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: locationID + "-aiplatform.googleapis.com", port: 443)

        self._client = .init(channel: channel)
    }

    func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        authorization = Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-platform"],
            eventLoopGroup: eventLoopGroup
        )
    }

#if DEBUG
    struct NotSetUpForDebugError: LocalizedError {

        let errorDescription: String? = "Make sure the environment key AI_PLATFORM_GOOGLE_APPLICATION_CREDENTIALS is set with a correct value."
    }

    func bootstrapForDebug(eventLoopGroup: EventLoopGroup) async throws {
        guard let credentialsPath = ProcessInfo.processInfo.environment["AI_PLATFORM_GOOGLE_APPLICATION_CREDENTIALS"] else {
            throw NotSetUpForDebugError()
        }
        authorization = try Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-platform"],
            provider: ServiceAccountProvider(credentialsURL: URL(fileURLWithPath: credentialsPath)),
            eventLoopGroup: eventLoopGroup
        )
    }
#endif

    // MARK: - Termination

    public func shutdown() async throws {
        try await authorization?.shutdown()
    }
}
