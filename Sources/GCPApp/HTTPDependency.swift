import NIO
import GCPCore
import AsyncHTTPClient

public protocol HTTPDependency: Dependency {

    static var isSecure: Bool { get }
    static var host: String { get }
    static var port: Int { get }

    static var _client: HTTPClient? { get }
    static func initClient(eventLoopGroup: EventLoopGroup)
}

extension HTTPDependency {

    public static var port: Int {
        isSecure ? 443 : 80
    }

    public static var client: HTTPClient {
        guard let _client = _client else {
            fatalError("\(self) has not been bootstrapped yet.")
        }
        return _client
    }

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        try await bootstrapForDevelopment(eventLoopGroup: eventLoopGroup)
#else
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
#endif
    }

    private static func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        self.initClient(eventLoopGroup: eventLoopGroup)
    }

#if DEBUG
    private static func bootstrapForDevelopment(eventLoopGroup: EventLoopGroup) async throws {
        self.initClient(eventLoopGroup: eventLoopGroup)
    }
#endif

    public static func shutdown() async throws {
        try await client.shutdown()
    }
}
