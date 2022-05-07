import Foundation
import GRPC

extension GRPCClient {

    /// Ensures the GRPC client has a valid authorization header for communication with GCP APIs.
    /// - Parameter client: The client to set authorization header on.
    public mutating func ensureAuthentication(authorization: inout Authorization) async throws {
#if DEBUG
        // Don't authorize in debug, unless we have credentials
        if ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"]?.isEmpty != false {
            return
        }
#endif

        let result = try await authorization.token()

        defaultCallOptions.customMetadata.replaceOrAdd(
            name: "authorization",
            value: "Bearer " + result.token
        )
    }
}
