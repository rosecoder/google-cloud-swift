import Logging
import OAuth2
import GRPC
import NIO
import Foundation

extension GoogleCloudLogHandler {

    enum AccessTokenError: Error {
        case noTokenProvider
        case tokenProviderFailed
    }

    static var rawClient: Google_Logging_V2_LoggingServiceV2Client!

    static func bootstrap(eventLoopGroup: EventLoopGroup) throws {

        func accessToken() throws -> String {
            guard let provider = DefaultTokenProvider(scopes: ["https://www.googleapis.com/auth/logging.write"]) else { throw AccessTokenError.noTokenProvider }

            let accessTokenPromise = eventLoopGroup.next().makePromise(of: String.self)

            try provider.withToken { token, error in
                guard let token = token, let accessToken = token.AccessToken else {
                    accessTokenPromise.fail(error ?? AccessTokenError.tokenProviderFailed)
                    return
                }

                accessTokenPromise.succeed(accessToken)
            }

            return try accessTokenPromise.futureResult.wait()
        }

        let channel = ClientConnection
            .secure(group: eventLoopGroup)
            .connect(host: "logging.googleapis.com", port: 443)

        let callOptions = CallOptions(
            customMetadata: ["authorization": "Bearer \(try accessToken())"],
            timeLimit: .deadline(.distantFuture)
        )

        rawClient = Google_Logging_V2_LoggingServiceV2Client(channel: channel, defaultCallOptions: callOptions)
    }
}
