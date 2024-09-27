import Foundation
import GRPC
import NIO
import CloudCore
import CloudTrace
import GoogleCloudAuth

public actor Translation: Dependency {

    public static let shared = Translation()

    private var _client: Google_Cloud_Translation_V3_TranslationServiceAsyncClient?

    func client(context: Context) async throws -> Google_Cloud_Translation_V3_TranslationServiceAsyncClient {
        if _client == nil {
            try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
        }
        var _client = _client!
        try await _client.ensureAuthentication(authorization: authorization, context: context, traceContext: "translation")
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
    }

    func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "translate.googleapis.com", port: 443)
        self._client = .init(channel: channel)

        authorization = Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-translation"],
            eventLoopGroup: eventLoopGroup
        )
    }

#if DEBUG
    struct NotSetUpForDebugError: LocalizedError {

        let errorDescription: String? = "Make sure the environment key TRANSLATION_GOOGLE_APPLICATION_CREDENTIALS is set with a correct value."
    }

    func bootstrapForDebug(eventLoopGroup: EventLoopGroup) async throws {
        guard let credentialsPath = ProcessInfo.processInfo.environment["TRANSLATION_GOOGLE_APPLICATION_CREDENTIALS"] else {
            throw NotSetUpForDebugError()
        }

        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "translate.googleapis.com", port: 443)
        self._client = .init(channel: channel)

        authorization = try Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-translation"],
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
