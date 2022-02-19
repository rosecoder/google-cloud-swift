import Foundation
import Logging
import NIO
import GCPCore
import GCPLogging

public protocol App {

    var eventLoopGroup: EventLoopGroup { get }
    var logger: Logger { get }

    var dependencies: [Dependency.Type] { get }
}

private let defaultEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
private let defaultLogger = Logger(label: "main")

extension App {

    public var eventLoopGroup: EventLoopGroup { defaultEventLoopGroup }
    public var logger: Logger { defaultLogger }

    public var dependencies: [Dependency.Type] { [] }

    public func main(boostrap: @escaping () async throws -> Void = {}) {
        Task {

            // Logging
            #if !DEBUG
            try! await GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
            LoggingSystem.bootstrap {
                GoogleCloudLogHandler(label: $0, resource: .autoResolve)
            }
            #endif

            // Error reporting
            // TODO: Implement

            // Tracing
            // TODO: Implement

            // Metrics
            // TODO: Implement

            // App dependencies
            for dependency in dependencies {
                do {
                    try await dependency.bootstrap(eventLoopGroup: eventLoopGroup)
                } catch {
                    logger.critical("Error bootstrapping app dependency: \(dependency)", metadata: [
                        "error": .string(String(describing: error)),
                    ])
                    exit(1)
                }
            }

            // App
            do {
                try await boostrap()
            } catch {
                logger.critical("Error bootstrapping app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                exit(1)
            }
        }

        RunLoop.main.run()
    }
}
