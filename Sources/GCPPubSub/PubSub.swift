import Foundation
import NIO
import GCPCore

struct PubSub {

    static var authorization: Authorization?

    // MARK: - Booostrap

    static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        guard ProcessInfo.processInfo.environment["PUBSUB_EMULATOR_HOST"]?.isEmpty != false else {
            return
        }

        authorization = try Authorization(scopes: [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/pubsub",
        ], eventLoopGroup: eventLoopGroup)

        try await authorization?.warmup()
    }

    // MARK: - Termination

    private static var isShutdown = false

    public static func shutdown() async throws {
        guard !isShutdown else {
            return
        }
        isShutdown = true

        try await authorization?.shutdown()
    }
}