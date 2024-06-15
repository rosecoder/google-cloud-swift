import Foundation
@preconcurrency import OAuth2Server
import Logging
import NIO
import RetryableTask

public actor Authorization: Sendable {

    private lazy var logger = Logger(label: "core.authorization")

    private var provider: TokenProvider & Sendable

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
    public func accessToken(file: String = #fileID, function: String = #function, line: UInt = #line) async throws -> String {
        try await withRetryableTask(logger: logger, operation: {
            let rawToken = try await provider.token()
            guard let accessToken = rawToken.AccessToken else {
                throw GenerateError.noAccessToken
            }
            return accessToken
        }, file: file, function: function, line: line)
    }

    public func warmup(file: String = #fileID, function: String = #function, line: UInt = #line) async throws {
        _ = try await accessToken(file: file, function: function, line: line)
    }

    public func shutdown() async throws {
        try await provider.shutdown()
    }
}
