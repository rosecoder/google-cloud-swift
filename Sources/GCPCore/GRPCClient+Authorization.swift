import Foundation
import GRPC

extension GRPCClient {

    /// Ensures the GRPC client has a valid authorization header for communication with GCP APIs.
    /// - Parameter client: The client to set authorization header on.
    public mutating func ensureAuthentication(authorization: inout Authorization) async throws {
        let accessToken = try await authorization.token()

        defaultCallOptions.customMetadata.replaceOrAdd(
            name: "authorization",
            value: "Bearer \(accessToken)"
        )
    }
}
