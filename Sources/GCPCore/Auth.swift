import Foundation
import OAuth2

public struct AccessToken {

    public let scopes: [String]

    public init(scopes: [String]) {
        self.scopes = scopes
    }

    // MARK: - Generate

    enum GenerateError: Error {
        case noTokenProvider
        case tokenProviderFailed
    }

    public func generate() async throws -> String {
        guard let provider = DefaultTokenProvider(scopes: scopes) else {
            throw GenerateError.noTokenProvider
        }

        return try await withCheckedThrowingContinuation { continuation in
            do {
                try provider.withToken { token, error in
                    if let token = token, let accessToken = token.AccessToken {
                        continuation.resume(returning: accessToken)
                    } else {
                        continuation.resume(throwing: error ?? GenerateError.tokenProviderFailed)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
