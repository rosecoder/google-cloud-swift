import Foundation
import Logging
import GRPC
import NIO
import CloudCore

public actor GoogleCloudLogging: Dependency {

    public static var shared = GoogleCloudLogging()

    private var _client: Google_Logging_V2_LoggingServiceV2AsyncClient?

    var client: Google_Logging_V2_LoggingServiceV2AsyncClient {
        get async throws {
            if _client == nil {
                authorization = try Authorization(scopes: [
                    "https://www.googleapis.com/auth/logging.write",
                ], eventLoopGroup: _unsafeInitializedEventLoopGroup)

                let channel = ClientConnection
                    .usingTLSBackedByNIOSSL(on: _unsafeInitializedEventLoopGroup)
                    .connect(host: "logging.googleapis.com", port: 443)

                _client = Google_Logging_V2_LoggingServiceV2AsyncClient(channel: channel)
            }

            var _client = _client!
            try await _client.ensureAuthentication(authorization: authorization)
            self._client = _client

            return _client
        }
    }

    var authorization: Authorization!

    /// Last task for publishing logging to GCP. Intended only for internal use while testing.
    private(set) var lastLogTask: Task<(), Error>?

    func log(operation: @escaping () async throws -> Void) {
        lastLogTask = Task {
            try await operation()
        }
    }

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        if GoogleCloudLogHandler.preferredMethod == .rpc {
            _ = try await client
        }
    }

    public func shutdown() async throws {
        try await lastLogTask?.value
        try await authorization?.shutdown()
    }
}
