import Foundation
import OAuth2Server
import Logging
import NIO

public actor Authorization {

    private lazy var logger = Logger(label: "core.authorization")

    private var provider: TokenProvider

    public enum Authentication {
        case autoResolve
        case serviceAccount(Data)
    }

    public init(scopes: [String], authentication: Authentication = .autoResolve, eventLoopGroup: EventLoopGroup) throws {
        switch authentication {
        case .autoResolve:
            provider = try DefaultTokenProvider(scopes: scopes, eventLoopGroupProvider: .shared(eventLoopGroup))
        case .serviceAccount(let data):
            provider = try ServiceAccountTokenProvider(credentialsData: data, scopes: scopes, eventLoopGroupProvider: .shared(eventLoopGroup))
        }
    }

    // MARK: - Low-level usage

    enum GenerateError: Error {
        case noAccessToken
    }

    /// Returns cached authorization token or generates a new one if needed.
    public func token() async throws -> (token: String, wasCached: Bool) {
        let rawToken = try await provider.token()
        guard let accessToken = rawToken.AccessToken else {
            throw GenerateError.noAccessToken
        }

        let wasCached: Bool
        if let creationTime = rawToken.CreationTime {
            wasCached = -creationTime.timeIntervalSinceNow > 60
        } else {
            wasCached = false
        }
        return (accessToken, wasCached)
    }

    public func warmup() async throws {
        _ = try await token()
    }

    public func shutdown() async throws {
        try await provider.shutdown()
    }
}
