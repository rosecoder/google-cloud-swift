import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCOTelTracingInterceptors
import Logging
import RetryableTask
import ServiceLifecycle

public struct GRPCServerService: Service {

    private let address: String
    private let grpcServer: GRPCServer<HTTP2ServerTransport.Posix>

    public init(
        services: [any RegistrableRPCService],
        host: String = "0.0.0.0",
        port: Int? = resolvePort(),
        defaultPort: Int = 3000,
        interceptors: (_ host: String) -> [ServerInterceptor] = defaultInterceptors
    ) {
        self.address = "\(host):\(port ?? defaultPort)"
        self.grpcServer = GRPCServer(
            transport: .http2NIOPosix(
                address: .ipv4(host: host, port: port ?? defaultPort),
                transportSecurity: .plaintext
            ),
            services: services,
            interceptors: interceptors(host)
        )
    }

    public static func resolvePort() -> Int? {
        if let rawPort = ProcessInfo.processInfo.environment["PORT"],
            let environmentPort = Int(rawPort)
        {
            return environmentPort
        }
        return nil
    }

    public static func defaultInterceptors(host: String) -> [ServerInterceptor] {
        let tracingInterceptor = ServerOTelTracingInterceptor(
            serverHostname: host,
            networkTransportMethod: "tcp"
        )
        #if DEBUG
            let isRunningViaXcode =
                ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"] != nil
            return [
                tracingInterceptor,
                RequestLoggerInterceptor(useLogger: isRunningViaXcode),
            ]
        #else
            return [
                tracingInterceptor
            ]
        #endif
    }

    public func run() async throws {
        await DefaultRetryPolicyConfiguration.shared.use(
            retryPolicy: DelayedRetryPolicy(
                delay: 10_000_000,  // 10 ms
                maxRetries: 1
            ))

        try await withGracefulShutdownHandler {
            try await withThrowingDiscardingTaskGroup { group in
                group.addTask {
                    try await grpcServer.serve()
                }
                group.addTask {
                    let logger = Logger(label: "grpc-server-service")
                    #if DEBUG
                        logger.debug("App running in debug on \(address) 🚀")
                    #else
                        logger.info("Bootstrap completed on \(address)")
                    #endif
                }
            }
        } onGracefulShutdown: {
            grpcServer.beginGracefulShutdown()
        }
    }
}
