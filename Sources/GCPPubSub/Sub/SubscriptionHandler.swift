import Foundation

public protocol SubscriptionHandler {

    func handle(message: SubscriberMessage) async throws
}
