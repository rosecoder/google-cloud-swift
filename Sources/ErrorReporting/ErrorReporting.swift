import Foundation
import Core
import NIO
import AsyncHTTPClient

public struct ErrorReporting {

    static var authorization: Authorization!

    private static var _client: HTTPClient?

    static var client: HTTPClient {
        get {
            guard let _client = _client else {
                fatalError("Must call ErrorReporting.bootstrap(eventLoopGroup:) first")
            }

            return _client
        }
        set {
            _client = newValue
        }
    }

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) throws {
        authorization = try Authorization(scopes: [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/stackdriver-integration",
        ], eventLoopGroup: eventLoopGroup)
        _client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    }

    // MARK: - Termination

    public static func shutdown() async throws {
        try await authorization?.shutdown()
    }
}
