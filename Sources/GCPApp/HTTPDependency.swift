import NIO
import GCPCore
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

    public static var port: Int {
        isSecure ? 443 : 80
    }

    public static var configuration: HTTPClient.Configuration {
        .init(
            timeout: .init(connect: .seconds(5), read: .seconds(60))
        )
    }

    // MARK: - Client

    public static var client: HTTPClient {
        guard let _client = _client else {
            fatalError("\(self) has not been bootstrapped yet.")
        }
        return _client
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