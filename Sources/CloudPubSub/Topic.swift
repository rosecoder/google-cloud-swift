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
}

#if DEBUG
extension Topic {

    func createIfNeeded(client: Google_Pubsub_V1_Publisher_ClientProtocol) async throws {
        do {
            try await client.createTopic(.with {
                $0.name = id
                $0.labels = labels
            })
        } catch {
            switch (error as? RPCError)?.code {
            case .alreadyExists:
                break
            default:
                throw error
            }
        }
    }
}
#endif
