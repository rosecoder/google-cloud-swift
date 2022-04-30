import Foundation
import GCPCore
import NIO
import AsyncHTTPClient

public struct ErrorReporting {

    static var authorization = Authorization(scopes: [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/stackdriver-integration",
    ])

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

    private static var _resource: Resource?

    static var resource: Resource {
        guard let _resource = _resource else {
            fatalError("Must call ErrorReporting.bootstrap(eventLoopGroup:) first")
        }

        return _resource
    }

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup, resource: Resource = .autoResolve) {
        _client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        _resource = resource
    }
}
