import Foundation
import NIO

public protocol Dependency {

    static func bootstrap(eventLoopGroup: EventLoopGroup) async throws
}
