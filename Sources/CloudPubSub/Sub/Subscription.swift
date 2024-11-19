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
        self.projectID = ServiceContext.topLevel.projectID!
    }

    // MARK: - Identifiable

    public var id: String {
        "projects/\(projectID)/subscriptions/\(name)"
    }

    // MARK: - Hashable

    public var rawValue: String {
        id
    }

    // MARK: - Creation

    func createIfNeeded(
        creation: @Sendable (Google_Pubsub_V1_Subscription) async throws -> Google_Pubsub_V1_Subscription,
        publisher: Publisher,
        pubSubService: PubSubService,
        logger: Logger
    ) async throws {
        try await pubSubService.createIfNeeded(hashValue: rawValue.hashValue) {
            do {
                _ = try await creation(.with {
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
                if "\(error)".hasPrefix("already exists (6):") {
                    return
                }
                if "\(error)".hasPrefix("not found (5):") {
                    try await topic.createIfNeeded(creation: {
                        try await publisher.client.createTopic($0)
                    }, pubSubService: pubSubService)
                    try await createIfNeeded(creation: creation, publisher: publisher, pubSubService: pubSubService, logger: logger)
                    return
                }
                throw error
            }
        }
    }
}
