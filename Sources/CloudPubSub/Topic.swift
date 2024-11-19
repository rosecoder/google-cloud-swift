import Foundation
import GRPCCore
import CloudCore
import ServiceContextModule
import GoogleCloudServiceContext

public struct Topics {}

public struct Topic<Message: _Message>: Sendable, Identifiable, Equatable, Hashable {

    public let name: String
    public let labels: [String: String]
    public let projectID: String

    public init(name: String, labels: [String: String] = [:]) {
        self.name = name
        self.labels = labels
        self.projectID = ServiceContext.topLevel.projectID!
    }

    // MARK: - Identifiable

    public var id: String {
        "projects/\(projectID)/topics/\(name)"
    }

    // MARK: - Hashable

    public var rawValue: String {
        id
    }

    // MARK: - Creation

    func createIfNeeded(creation: @Sendable (Google_Pubsub_V1_Topic) async throws -> Google_Pubsub_V1_Topic, pubSubService: PubSubService) async throws {
        try await pubSubService.createIfNeeded(hashValue: rawValue.hashValue) {
            do {
                _ = try await creation(.with {
                    $0.name = id
                    $0.labels = labels
                })
            } catch {
                if !"\(error)".hasPrefix("already exists (6):") {
                    throw error
                }
            }
        }
    }
}
