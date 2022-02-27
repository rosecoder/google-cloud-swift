import Foundation
import Logging
import OAuth2
import GRPC
import NIO
import GCPCore

extension GoogleCloudLogHandler: Dependency {

    static var _client: Google_Logging_V2_LoggingServiceV2AsyncClient!

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "logging.googleapis.com", port: 443)

        let accessToken = try await AccessToken(
            scopes: ["https://www.googleapis.com/auth/logging.write"]
        ).generate(didRefresh: { accessToken in
            _client?.defaultCallOptions.customMetadata.replaceOrAdd(name: "authorization", value: "Bearer \(accessToken)")
        })

        let callOptions = CallOptions(
            customMetadata: ["authorization": "Bearer \(accessToken)"],
            timeLimit: .deadline(.distantFuture)
        )
        _client = Google_Logging_V2_LoggingServiceV2AsyncClient(channel: channel, defaultCallOptions: callOptions)
    }

    public static func shutdown() async throws {
        try await lastLogTask?.value
    }
}
