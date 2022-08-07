import Foundation
import GRPC

extension GRPCClient {

    /// Ensures the GRPC client has a valid authorization header for communication with GCP APIs.
    /// - Parameter client: The client to set authorization header on.
    public mutating func ensureAuthentication(authorization: Authorization?) async throws {
        guard let authorization = authorization else {
            return
        }

        let result = try await authorization.token()

        defaultCallOptions.customMetadata.replaceOrAdd(
            name: "authorization",
            value: "Bearer " + result.token
        )
    }
}
