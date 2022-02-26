import Foundation
import Logging
import NIO
import GCPCore
import GCPLogging

public protocol App {

    var eventLoopGroup: EventLoopGroup { get }

    var logger: Logger { get }
    var logLevel: Logger.Level { get }

    var dependencies: [Dependency.Type] { get }

    func shutdown() async throws
}

private let defaultEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
private let defaultLogger = Logger(label: "main")

public typealias Dependency = GCPCore.Dependency

extension App {

    public var eventLoopGroup: EventLoopGroup { defaultEventLoopGroup }

    public var logger: Logger { defaultLogger }
    #if DEBUG
    public var logLevel: Logger.Level { .debug }
    #else
    public var logLevel: Logger.Level { .info }
    #endif

    public var dependencies: [Dependency.Type] { [] }

    public func main(boostrap: @escaping () async throws -> Void = {}) {
        catchGracefulTermination()

        Task {

            // Logging
            #if DEBUG
            LoggingSystem.bootstrap {
                var handler = StreamLogHandler.standardOutput(label: $0)
                handler.logLevel = logLevel
                return handler
            }
            #else
            try! await GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
            LoggingSystem.bootstrap {
                var handler = GoogleCloudLogHandler(label: $0, resource: .autoResolve)
                handler.logLevel = logLevel
                return handler
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
                    terminate(exitCode: 1)
                }
            }

            // App
            do {
                try await boostrap()
            } catch {
                logger.critical("Error bootstrapping app", metadata: [
                    "error": .string(String(describing: error)),
                ])
                terminate(exitCode: 1)
            }

            // Ready!
            #if DEBUG
            logger.debug("App running in debug 🚀")
            #else
            logger.info("Bootstrap completed")
            #endif
        }

        RunLoop.main.run()

        terminate(exitCode: 0)
    }

    public func shutdown() async throws {}
}
