import NIO
import CloudCore
import AsyncHTTPClient

public protocol HTTPDependency: Dependency {

    static var isSecure: Bool { get }
    static var host: String { get }
    static var port: Int { get }

    static var configuration: HTTPClient.Configuration { get }

    static var _client: HTTPClient? { get set }
}

extension HTTPDependency {

    // MARK: - Default Implementation

    public static var endpoint: String {
        (isSecure ? "https" : "http") + "://" + host + (defaultPort != port ? (":" + String(port)) : "")
    }

    public static var defaultPort: Int {
        isSecure ? 443 : 80
    }

    public static var port: Int {
        defaultPort
    }

    public static var configuration: HTTPClient.Configuration {
        .init(
            timeout: .init(connect: .seconds(5), read: .seconds(60))
        )
    }

    // MARK: - Client

    public static var client: HTTPClient {
        get async throws {
            if _client == nil {
                try await bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
            }
            return _client!
        }
    }

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        _client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup), configuration: configuration)
    }

    // MARK: - Termination

    public static func shutdown() async throws {
        try await client.shutdown()
    }
}
