import Foundation

public protocol SubscriptionHandler {

    func handle(message: inout SubscriberMessage) async throws
}
