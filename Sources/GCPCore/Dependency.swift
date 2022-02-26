import Foundation
import NIO

public protocol Dependency {

    static func bootstrap(eventLoopGroup: EventLoopGroup) async throws

    static func shutdown() async throws
}


extension Dependency {

    public static func shutdown() async throws {}
}
