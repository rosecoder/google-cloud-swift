import Foundation
import GRPCCore
import AsyncHTTPClient
import CloudCore

/// Interceptor which adds authorization header for all requests.
///
/// This can be used when a Cloud Run service requires authentication from a service account.
///
/// See: https://cloud.google.com/run/docs/authenticating/service-to-service
public actor CloudRunAuthenticateInterceptor: ClientInterceptor {

    public let targetAudience: String

    private var activeIDTokenTask: Task<(String, Date), Error>?
    private let client = HTTPClient(eventLoopGroupProvider: .shared(.singletonMultiThreadedEventLoopGroup))

    /// Initialize the interceptor for a Cloud Run service.
    /// - Parameter host: The host of the service. For example `my-service.my-project.a.run.app`.
    public init(host: String) {
        self.targetAudience = "https://" + host + "/"
    }

    public nonisolated func intercept<Input: Sendable, Output: Sendable>(
        request: StreamingClientRequest<Input>,
        context: ClientContext,
        next: (StreamingClientRequest<Input>, ClientContext) async throws -> StreamingClientResponse<Output>
    ) async throws -> StreamingClientResponse<Output> where Input : Sendable, Output : Sendable {
        var request = request

        let accessToken = try await idToken()
        request.metadata.addString("Bearer " + accessToken, forKey: "authorization")

        return try await next(request, context)
    }

    private struct IDTokenPayload: Decodable {

        let exp: TimeInterval
    }

    private enum IDTokenError: Error {
        case noData
        case notJWT(String)
        case invalidJWTPayload(String)
    }

    private func idToken() async throws -> String {
        if let task = activeIDTokenTask {
            let (idToken, expiration) = try await task.value
            if expiration >= Date() {
                return idToken
            }
        }

        let task = Task {
            return try await requestIDToken()
        }
        activeIDTokenTask = task
        return try await task.value.0
    }

    private func requestIDToken() async throws -> (String, Date) {
        var urlComponents = URLComponents(string: "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity")!
        urlComponents.queryItems = [
            .init(name: "audience", value: targetAudience),
        ]

        var request = HTTPClientRequest(url: urlComponents.string!)
        request.headers.add(name: "Metadata-Flavor", value: "Google")

        let response = try await client.execute(request, timeout: .seconds(5))
        let body = try await response.body.collect(upTo: 1024 * 10) // 10 KB

        let idToken = String(buffer: body)
        let jwtComponents = idToken.components(separatedBy: ".")
        guard jwtComponents.count >= 3 else {
            throw IDTokenError.notJWT(idToken)
        }
        var payloadBase64String = jwtComponents[1]

        // Add missing padding
        let remainder = payloadBase64String.count % 4
        if remainder > 0 {
            payloadBase64String = payloadBase64String.padding(toLength: payloadBase64String.count + 4 - remainder, withPad: "=", startingAt: 0)
        }

        guard let payloadData = Data(base64Encoded: payloadBase64String) else {
            throw IDTokenError.invalidJWTPayload(payloadBase64String)
        }

        let payload = try JSONDecoder().decode(IDTokenPayload.self, from: payloadData)
        let expiration = Date(timeIntervalSince1970: payload.exp)

        return (idToken, expiration)
    }
}
