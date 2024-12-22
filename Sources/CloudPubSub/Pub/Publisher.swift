import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2Posix
import NIO
import Logging
import Tracing
import CloudCore
import SwiftProtobuf
import RetryableTask

public final class Publisher: PublisherProtocol {

    private let logger = Logger(label: "pubsub.publisher")

    let client: Google_Pubsub_V1_Publisher.ClientProtocol
    private let pubSubService: PubSubService

    public enum ConfigurationError: Error {
        case missingProjectID
    }

    public let projectID: String

    public convenience init(pubSubService: PubSubService) async throws {
        guard let projectID = await (ServiceContext.current ?? .topLevel).projectID else {
            throw ConfigurationError.missingProjectID
        }
        self.init(pubSubService: pubSubService, projectID: projectID)
    }

    public init(pubSubService: PubSubService, projectID: String) {
        self.projectID = projectID
        self.client = Google_Pubsub_V1_Publisher.Client(wrapping: pubSubService.grpcClient)
        self.pubSubService = pubSubService
    }

    // MARK: - Publish

    @discardableResult
    public func publish<Message>(
        to topic: Topic<Message>,
        messages: [Message.Outgoing],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [PublishedMessage] {
        try await withRetryableTask(logger: logger, operation: {
            logger.debug("Publishing \(messages.count) message(s)...")

#if DEBUG
            try await topic.createIfNeeded(client: client, projectID: projectID)
#endif

            let response: Google_Pubsub_V1_PublishResponse = try await withSpan("pubsub-publish", ofKind: .producer) { span in
                span.attributes["pubsub/topic"] = topic.rawValue
                return try await client.publish(.with {
                    $0.topic = topic.rawValue
                    $0.messages = messages.map { message in
                        Google_Pubsub_V1_PubsubMessage.with {
                            $0.data = message.data
                            $0.attributes = message.attributes
//                            if let trace = context.trace {
//                                $0.attributes["__traceID"] = trace.id.stringValue
//                                $0.attributes["__spanID"] = (trace.rootSpan?.id ?? trace.spanID).stringValue
//                            }
                        }
                    }
                })
            }

            return response
                .messageIds
                .map { PublishedMessage(id: $0) }
        }, file: file, function: function, line: line)
    }
}
