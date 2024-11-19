import NIO
import CloudCore
import AsyncHTTPClient
import ServiceLifecycle

public struct HTTPService: Service {

    public let client: HTTPClient

    public init(
        configuration: HTTPClient.Configuration = .init(
            timeout: .init(connect: .seconds(5), read: .seconds(60))
        )
    ) {
        self.client = HTTPClient(
            eventLoopGroupProvider: .shared(.singletonMultiThreadedEventLoopGroup),
            configuration: configuration
        )
    }

    public func run() async throws {
        await cancelWhenGracefulShutdown {
            try? await Task.sleepUntilCancelled()
        }

        try await client.shutdown()
    }
}
