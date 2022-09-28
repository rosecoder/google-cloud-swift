import Foundation
import NIO

public var _unsafeInitializedEventLoopGroup: EventLoopGroup!

public protocol Dependency {

    static func bootstrap(eventLoopGroup: EventLoopGroup) async throws

    static func shutdown() async throws
}

extension Dependency {

    public static func shutdown() async throws {}
}
