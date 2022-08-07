import Foundation
import GRPC
import GCPCore

extension GRPCClient {

    /// Ensures the GRPC client has a valid authorization header for communication with GCP APIs.
    /// - Parameter client: The client to set authorization header on.
    public mutating func ensureAuthentication(authorization: Authorization?, context: Context, traceContext: String) async throws {
        guard let authorization = authorization else {
            return
        }

        var span = context.trace?.span(named: "authenticate-" + traceContext, kind: .client)
        do {
            let result = try await authorization.token()

            if result.wasCached {
                span?.abort()
            } else {
                span?.end(statusCode: .ok)
            }

            defaultCallOptions.customMetadata.replaceOrAdd(
                name: "authorization",
                value: "Bearer " + result.token
            )
        } catch {
            span?.end(error: error)
            throw error
        }
    }
}
