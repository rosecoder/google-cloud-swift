import Foundation
import GRPC
import CloudCore

extension GRPCClient {

    /// Ensures the GRPC client has a valid authorization header for communication with GCP APIs.
    /// - Parameter client: The client to set authorization header on.
    public mutating func ensureAuthentication(authorization: Authorization?, context: Context, traceContext: String) async throws {
        guard let authorization = authorization else {
#if !DEBUG
        context.logger.debug("Skipped authentication with client because authorization is not set.")
#endif
            return
        }

#if !DEBUG
        context.logger.debug("Getting access token for client...")
#endif

        var span = context.trace?.span(named: "authenticate-" + traceContext, kind: .client)
        do {
            let accessToken = try await authorization.accessToken()

            if var span = span {
                if -span.started.timeIntervalSinceNow < 0.01 {
                    span.abort()
                } else {
                    span.end(statusCode: .ok)
                }
            }

            defaultCallOptions.customMetadata.replaceOrAdd(
                name: "authorization",
                value: "Bearer " + accessToken
            )

#if !DEBUG
            context.logger.debug("Included access token in header for client.")
#endif
        } catch {
            span?.end(error: error)
            throw error
        }
    }
}
