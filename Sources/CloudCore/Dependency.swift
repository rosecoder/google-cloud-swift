import Foundation
import NIO

nonisolated(unsafe) public var _unsafeInitializedEventLoopGroup: EventLoopGroup!

public protocol Dependency: Actor {

    static var shared: Self { get }

    func bootstrap(eventLoopGroup: EventLoopGroup) async throws

    func shutdown() async throws
}

extension Dependency {

    public func shutdown() async throws {}
}
