import Foundation
import CloudCore
import NIO
import AsyncHTTPClient
import GoogleCloudAuth

public actor ErrorReporting: Dependency {

    public static let shared = ErrorReporting()

    var authorization: Authorization!

    private var _client: HTTPClient?

    var client: HTTPClient {
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

    public func bootstrap(eventLoopGroup: EventLoopGroup) throws {
        authorization = Authorization(scopes: [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/stackdriver-integration",
        ], eventLoopGroup: eventLoopGroup)
        _client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    }

    // MARK: - Termination

    public func shutdown() async throws {
        try await authorization?.shutdown()
    }
}
