import GRPCCore
import GoogleCloudAuth

public struct AuthorizationClientInterceptor: ClientInterceptor {

    private let authorization: Authorization

    public init(authorization: Authorization) {
        self.authorization = authorization
    }

    public func intercept<Input: Sendable, Output: Sendable>(
        request: StreamingClientRequest<Input>,
        context: ClientContext,
        next: (StreamingClientRequest<Input>, ClientContext) async throws -> StreamingClientResponse<Output>
    ) async throws -> StreamingClientResponse<Output> {
        var request = request

        let accessToken = try await authorization.accessToken()
        request.metadata.addString("Bearer " + accessToken, forKey: "authorization")

        return try await next(request, context)
    }
}
