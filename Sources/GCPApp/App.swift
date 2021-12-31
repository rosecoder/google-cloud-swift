import Foundation
import Logging
import NIO
import GCPCore
import GCPLogging

private let defaultEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

public protocol App {

    var eventLoopGroup: EventLoopGroup { get }

    var dependencies: [Dependency.Type] { get }
}

extension App {

    public var eventLoopGroup: EventLoopGroup { defaultEventLoopGroup }

    public var dependencies: [Dependency.Type] { [] }

    public func main(boostrap: @escaping () async throws -> Void = {}) {
        Task {

            // Logging
            try! await GoogleCloudLogHandler.bootstrap(eventLoopGroup: eventLoopGroup)
            LoggingSystem.bootstrap {
                GoogleCloudLogHandler(label: $0, resource: .autoResolve)
            }

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
                    fatalError("Error bootstrapping app dependency: \(error)")
                }
            }

            // App
            do {
                try await boostrap()
            } catch {
                fatalError("Error bootstrapping app: \(error)")
            }
        }

        RunLoop.main.run()
    }
}
