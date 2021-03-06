import Foundation
import OAuth2
import Logging

public struct Authorization {

    private lazy var logger = Logger(label: "core.authorization")

    public let scopes: [String]

    public enum Authentication {
        case autoResolve
        case serviceAccount(Data)
    }

    private let authentication: Authentication

    public init(scopes: [String], authentication: Authentication = .autoResolve) {
        self.scopes = scopes
        self.authentication = authentication
    }

    // MARK: - Low-level usage

    private let overestimatedExpiresLatency: TimeInterval = 120 // 2 minutes
    private let estimatedExpiresLatency: TimeInterval = 60 // 1 minute

    fileprivate struct Token {

        let accessToken: String
        let expires: Date?
    }

    private var generateTask: Task<Token, Error>?
    private var generateTaskFinished = false

    /// Returns cached authorization token or generates a new one if needed.
    public mutating func token() async throws -> (token: String, wasCached: Bool) {

        let wasCached = generateTaskFinished

        // Get existing generate task or start a new one
        let generateTask: Task<Token, Error>
        if let existing = self.generateTask {
            generateTask = existing
        } else {
            let scopes = self.scopes
            let authentication = self.authentication
            generateTask = Task {
                try await TokenGenerator.shared.generate(scopes: scopes, authentication: authentication)
            }
            self.generateTask = generateTask
            self.generateTaskFinished = false
        }

        // Wait for token to be generated
        let token: Token
        do {
            token = try await generateTask.value
            self.generateTaskFinished = true
        } catch {
            logger.error("Failed getting access token: \(error)")

            // If generating fails, fail for this call, but clear task to retry on next call
            self.generateTask = nil
            self.generateTaskFinished = false

            throw error
        }

        // Check token expiration if needed
        if let expires = token.expires {

            let timeIntervalToExpiration = expires.timeIntervalSinceNow

            // Need refresh directly?
            if timeIntervalToExpiration < estimatedExpiresLatency {
                self.generateTask = nil
                self.generateTaskFinished = false
                return try await self.token()
            }

            // Need refresh soon?
            if timeIntervalToExpiration < overestimatedExpiresLatency {
                self.generateTask = nil
                self.generateTaskFinished = false
            }
        }

        return (token.accessToken, wasCached)
    }

    public mutating func warmup() async throws {
        _ = try await token()
    }
}

// MARK: - Generate

private actor TokenGenerator {

    private lazy var logger = Logger(label: "core.authorization")

    static let shared = TokenGenerator()

    enum GenerateError: Error {
        case noTokenProvider
        case tokenProviderFailed
        case expiresTooShort
    }

    func generate(scopes: [String], authentication: Authorization.Authentication) async throws -> Authorization.Token {
        let provider: TokenProvider?
        switch authentication {
        case .autoResolve:
            provider = DefaultTokenProvider(scopes: scopes)
        case .serviceAccount(let data):
            provider = ServiceAccountTokenProvider(credentialsData: data, scopes: scopes)
        }

        guard let provider = provider else {
            throw GenerateError.noTokenProvider
        }

        return try await withCheckedThrowingContinuation { continuation in

            let completion: (OAuth2.Token?, Error?) -> Void = { token, error in
                do {
                    guard let token = token, let accessToken = token.AccessToken else {
                        if let error = error {
                            throw error
                        }
                        self.logger.warning("No error given from provider", metadata: [
                            "token": .string(token.flatMap { "\($0)" } ?? "nil"),
                        ])
                        throw GenerateError.tokenProviderFailed
                    }

                    let expires: Date? = try token.ExpiresIn.flatMap { expiresIn in
                        if expiresIn < 60 * 5 { // if expires is too short it could result in infinite loop of refresh
                            throw GenerateError.expiresTooShort
                        }

                        return Date(timeIntervalSinceNow: TimeInterval(expiresIn))
                    }

                    // Success!
                    continuation.resume(returning: Authorization.Token(accessToken: accessToken, expires: expires))
                } catch {
                    continuation.resume(throwing: error)
                }
            }

            do {
                try provider.withToken(completion)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
