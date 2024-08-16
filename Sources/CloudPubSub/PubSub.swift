import Foundation
import NIO
import CloudCore

actor PubSub {

    static let shared = PubSub()

    var authorization: Authorization?

    // MARK: - Booostrap

    func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        guard ProcessInfo.processInfo.environment["PUBSUB_EMULATOR_HOST"]?.isEmpty != false else {
            return
        }

        if authorization == nil {
            authorization = try Authorization(scopes: [
                "https://www.googleapis.com/auth/cloud-platform",
                "https://www.googleapis.com/auth/pubsub",
            ], eventLoopGroup: eventLoopGroup)

            try await authorization?.warmup()
        }
    }

    // MARK: - Termination

    private var isShutdown = false

    public func shutdown() async throws {
        guard !isShutdown else {
            return
        }
        isShutdown = true

        try await authorization?.shutdown()
    }

    // MARK: - Create if needed

    private var verifiedHashValues = [Int]()

    func createIfNeeded(
        hashValue: Int,
        creation: @Sendable () async throws -> Void
    ) async throws {
        guard !verifiedHashValues.contains(hashValue) else {
            return
        }
        try await creation()
        verifiedHashValues.append(hashValue)
    }
}
