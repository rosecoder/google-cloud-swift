import CloudPubSub
import Logging

extension Handler {

    public func handle(message: Incoming) async throws {
        try await handle(
            message: message,
            context: .fake(logger: Logger(label: subscription.name))
        )
    }
}
