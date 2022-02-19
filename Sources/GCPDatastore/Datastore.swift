import Foundation
import GRPC
import NIO
import OAuth2
import GCPCore

public struct Datastore: Dependency {

    private static var _client: Google_Datastore_V1_DatastoreAsyncClient?

    static var client: Google_Datastore_V1_DatastoreAsyncClient {
        guard let _client = _client else {
            fatalError("Must call Datastore.bootstrap(eventLoopGroup:) first")
        }

        return _client
    }

    public static var defaultProjectID: String = ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] ?? ""

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        if let host = ProcessInfo.processInfo.environment["DATASTORE_EMULATOR_HOST"] {
            bootstraForEmulator(host: host, eventLoopGroup: eventLoopGroup)
        } else {
            try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
        }
    }

    static func bootstraForEmulator(host: String, eventLoopGroup: EventLoopGroup) {
        let components = host.components(separatedBy: ":")
        let port = Int(components[1])!

        let channel = ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: components[0], port: port)

        self._client = .init(channel: channel)
    }

    static func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "datastore.googleapis.com", port: 443)

        let accessToken = try await AccessToken(scopes: ["https://www.googleapis.com/auth/datastore"]).generate()
        let callOptions = CallOptions(
            customMetadata: ["authorization": "Bearer \(accessToken)"]
        )

        self._client = .init(channel: channel, defaultCallOptions: callOptions)
    }
}
