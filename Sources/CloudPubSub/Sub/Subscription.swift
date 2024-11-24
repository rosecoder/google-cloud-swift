import Foundation
import GRPCCore
import Logging
import CloudCore
import ServiceContextModule
import GoogleCloudServiceContext

public struct Subscriptions {}

public struct Subscription<Message: _Message>: Sendable, Identifiable, Equatable, Hashable {

    public let name: String
    public let topic: Topic<Message>

    public let labels: [String: String]

    public let retainAcknowledgedMessages: Bool
    public let acknowledgeDeadline: TimeInterval
    public let expirationPolicyDuration: TimeInterval
    public let messageRetentionDuration: TimeInterval

    public struct DeadLetterPolicy: Sendable, Equatable, Hashable {

        public let topic: Topic<Message>
        public let maxDeliveryAttempts: Int32

        public init(topic: Topic<Message>, maxDeliveryAttempts: Int32) {
            self.topic = topic
            self.maxDeliveryAttempts = maxDeliveryAttempts
        }
    }

    public let deadLetterPolicy: DeadLetterPolicy?

    public let projectID: String

    public init(
        name: String,
        topic: Topic<Message>,
        labels: [String: String] = [:],
        retainAcknowledgedMessages: Bool = false,
        acknowledgeDeadline: TimeInterval = 10,
        expirationPolicyDuration: TimeInterval = 3600 * 24 * 31,
        messageRetentionDuration: TimeInterval = 3600 * 24 * 6,
        deadLetterPolicy: DeadLetterPolicy? = nil
    ) {
        self.name = name
        self.topic = topic
        self.labels = labels
        self.retainAcknowledgedMessages = retainAcknowledgedMessages
        self.acknowledgeDeadline = acknowledgeDeadline
        self.expirationPolicyDuration = expirationPolicyDuration
        self.messageRetentionDuration = messageRetentionDuration
        self.deadLetterPolicy = deadLetterPolicy
#if DEBUG
        self.projectID = ServiceContext.topLevel.projectID ?? "development"
#else
        self.projectID = ServiceContext.topLevel.projectID!
#endif
    }

    // MARK: - Identifiable

    public var id: String {
        "projects/\(projectID)/subscriptions/\(name)"
    }

    // MARK: - Hashable

    public var rawValue: String {
        id
    }
}

#if DEBUG
extension Subscription {

    func createIfNeeded(
        subscriberClient: Google_Pubsub_V1_Subscriber_ClientProtocol,
        publisherClient: Google_Pubsub_V1_Publisher_ClientProtocol,
        createTopicIfNeeded: Bool = true
    ) async throws {
        do {
            _ = try await subscriberClient.createSubscription(.with {
                $0.name = id
                $0.labels = labels
                $0.topic = topic.rawValue
                $0.ackDeadlineSeconds = Int32(acknowledgeDeadline)
                $0.retainAckedMessages = retainAcknowledgedMessages
                $0.messageRetentionDuration = .with {
                    $0.seconds = Int64(messageRetentionDuration)
                }
                $0.expirationPolicy = .with {
                    $0.ttl = .with {
                        $0.seconds = Int64(expirationPolicyDuration)
                    }
                }
                if let deadLetterPolicy = deadLetterPolicy {
                    $0.deadLetterPolicy = .with {
                        $0.deadLetterTopic = deadLetterPolicy.topic.rawValue
                        $0.maxDeliveryAttempts = deadLetterPolicy.maxDeliveryAttempts
                    }
                }
            })
        } catch {
            switch (error as? RPCError)?.code {
            case .alreadyExists:
                break
            case .notFound:
                if !createTopicIfNeeded {
                    throw error
                }
                try await topic.createIfNeeded(client: publisherClient)
                try await createIfNeeded(subscriberClient: subscriberClient, publisherClient: publisherClient, createTopicIfNeeded: false)
            default:
                throw error
            }
        }
    }
}
#endif
