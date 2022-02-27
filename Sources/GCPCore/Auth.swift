import Foundation
import OAuth2
import Logging

private let refreshTimeOffset: TimeInterval = -5

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

    public func generate(didRefresh: ((String) -> Void)?) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            _generate { result in
                continuation.resume(with: result.map { $0.token })

                switch result {
                case .success(let value):
                    if let didRefresh = didRefresh {
                        scheduleRefresh(result: value, didRefresh: didRefresh)
                    }
                default:
                    break
                }
            }
        }
    }

    private func scheduleRefresh(result: (token: String, expiresIn: Int?), didRefresh: @escaping (String) -> Void) {
        guard let expiresIn = result.expiresIn else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: TimeInterval(expiresIn) + refreshTimeOffset, repeats: false) { _ in
            refresh(didRefresh: didRefresh)
        }
    }

    private func refresh(didRefresh: @escaping (String) -> Void) {
        let logger = Logger(label: "core.auth")

        logger.debug("Refreshing access token...")

        _generate { result in
            switch result {
            case .success(let value):
                scheduleRefresh(result: value, didRefresh: didRefresh)
            case .failure(let error):
                logger.error("Failed to refresh access token: \(error)")

                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    refresh(didRefresh: didRefresh)
                }
            }
        }
    }

    private func _generate(completion: @escaping (Result<(token: String, expiresIn: Int?), Error>) -> Void) {
        guard let provider = DefaultTokenProvider(scopes: scopes) else {
            completion(.failure(GenerateError.noTokenProvider))
            return
        }

        do {
            try provider.withToken { token, error in
                if let token = token, let accessToken = token.AccessToken {
                    completion(.success((accessToken, token.ExpiresIn)))
                } else {
                    completion(.failure(error ?? GenerateError.tokenProviderFailed))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
