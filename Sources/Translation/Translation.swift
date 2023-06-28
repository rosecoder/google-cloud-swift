import Foundation
import GRPC
import NIO
import Core

public struct Translation: Dependency {

    private static var _client: Google_Cloud_Translation_V3_TranslationServiceAsyncClient?

    static var client: Google_Cloud_Translation_V3_TranslationServiceAsyncClient {
        get {
            guard let _client = _client else {
                fatalError("Must call Translation.bootstrap(eventLoopGroup:) first")
            }

            return _client
        }
        set {
            _client = newValue
        }
    }

    static var authorization: Authorization?

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        try await bootstrapForDebug(eventLoopGroup: eventLoopGroup)
#else
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
#endif
    }

    static func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "translate.googleapis.com", port: 443)
        self._client = .init(channel: channel)

        authorization = try Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-translation"],
            eventLoopGroup: eventLoopGroup
        )
        try await authorization?.warmup()
    }

#if DEBUG
    struct NotSetUpForDebugError: LocalizedError {

        let errorDescription: String? = "Make sure the environment key TRANSLATION_GOOGLE_APPLICATION_CREDENTIALS is set with a correct value."
    }

    static func bootstrapForDebug(eventLoopGroup: EventLoopGroup) async throws {
        guard let credentialsPath = ProcessInfo.processInfo.environment["TRANSLATION_GOOGLE_APPLICATION_CREDENTIALS"] else {
            throw NotSetUpForDebugError()
        }

        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "translate.googleapis.com", port: 443)
        self._client = .init(channel: channel)

        authorization = try Authorization(
            scopes: ["https://www.googleapis.com/auth/cloud-translation"],
            authentication: .serviceAccount(try Data(contentsOf: URL(fileURLWithPath: credentialsPath))),
            eventLoopGroup: eventLoopGroup
        )
        try await authorization?.warmup()
    }
#endif

    // MARK: - Termination

    public static func shutdown() async throws {
        try await authorization?.shutdown()
    }
}
