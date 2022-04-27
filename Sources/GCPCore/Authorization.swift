import Foundation
import OAuth2
import Logging

public struct Authorization {

    private lazy var logger = Logger(label: "core.authorization")

    public let scopes: [String]

    public init(scopes: [String]) {
        self.scopes = scopes
    }

    // MARK: - Low-level usage

    private let overestimatedExpiresLatency: TimeInterval = 120 // 2 minutes
    private let estimatedExpiresLatency: TimeInterval = 60 // 1 minute

    fileprivate struct Token {

        let accessToken: String
        let expires: Date?
    }

    private var generateTask: Task<Token, Error>?

    /// Returns cached authorization token or generates a new one if needed.
    public mutating func token() async throws -> String {

        // Get existing generate task or start a new one
        let generateTask: Task<Token, Error>
        if let existing = self.generateTask {
            generateTask = existing
        } else {
            logger.debug("No authorization token task exists. Creating one...")

            let scopes = self.scopes
            generateTask = Task {
                try await TokenGenerator.shared.generate(scopes: scopes)
            }
            self.generateTask = generateTask
        }

        // Wait for token to be generated
        let token: Token
        do {
            token = try await generateTask.value
        } catch {
            logger.error("Error generating authorization token", metadata: [
                "error": .string(String(describing: error)),
            ])

            // If generating fails, fail for this call, but clear task to retry on next call
            self.generateTask = nil

            throw error
        }

        // Check token expiration if needed
        if let expires = token.expires {

            let timeIntervalToExpiration = expires.timeIntervalSinceNow

            // Need refresh directly?
            if timeIntervalToExpiration < estimatedExpiresLatency {
                logger.debug("Authorization expires soon. Refreshing...")

                self.generateTask = nil
                return try await self.token()
            }

            // Need refresh soon?
            if timeIntervalToExpiration < overestimatedExpiresLatency {
                logger.debug("Authorization expires soon. Refreshing next time...")

                self.generateTask = nil
            }
        }

        return token.accessToken
    }
}

// MARK: - Generate

private actor TokenGenerator {

    static let shared = TokenGenerator()

    enum GenerateError: Error {
        case noTokenProvider
        case tokenProviderFailed
        case expiresTooShort
    }

    func generate(scopes: [String]) async throws -> Authorization.Token {
        guard let provider = DefaultTokenProvider(scopes: scopes) else {
            throw GenerateError.noTokenProvider
        }

        return try await withCheckedThrowingContinuation { continuation in

            let completion: (OAuth2.Token?, Error?) -> Void = { token, error in
                do {
                    guard let token = token, let accessToken = token.AccessToken else {
                        throw error ?? GenerateError.tokenProviderFailed
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
