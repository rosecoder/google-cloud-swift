import Foundation
import Logging
import OAuth2
import GRPC
import NIO
import GCPCore

extension GoogleCloudLogHandler: Dependency {

    static var _client: Google_Logging_V2_LoggingServiceV2AsyncClient!

    static var authorization = Authorization(scopes: [
        "https://www.googleapis.com/auth/logging.write",
    ])

    public static func bootstrap(eventLoopGroup: EventLoopGroup) {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "logging.googleapis.com", port: 443)

        _client = Google_Logging_V2_LoggingServiceV2AsyncClient(channel: channel)
    }

    public static func shutdown() async throws {
        try await lastLogTask?.value
    }
}
