import Foundation
import GRPCCore
import CloudCore
import ServiceContextModule
import GoogleCloudServiceContext

public struct Topics {}

public struct Topic<Message: _Message>: Sendable, Equatable, Hashable {

    public let name: String
    public let labels: [String: String]

    public init(name: String, labels: [String: String] = [:]) {
        self.name = name
        self.labels = labels
    }

    // MARK: - Identifiable

    public func id(projectID: String) -> String {
        "projects/\(projectID)/topics/\(name)"
    }

    // MARK: - Hashable

    public var rawValue: String {
        name
    }
}

#if DEBUG
extension Topic {

    func createIfNeeded(client: Google_Pubsub_V1_Publisher.ClientProtocol, projectID: String) async throws {
        do {
            _ = try await client.createTopic(.with {
                $0.name = id(projectID: projectID)
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
