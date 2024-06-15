import Foundation
import GRPC
import CloudCore

private var verifiedHashValues = [Int]()

public struct Topics {}

public struct Topic<Message: _Message>: Identifiable, Equatable, Hashable{

    public let name: String
    public let labels: [String: String]
    public let projectID: String

    public init(name: String, labels: [String: String] = [:]) {
        self.name = name
        self.labels = labels
        self.projectID = Environment.resolveCurrent()!._projectID
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

    func createIfNeeded(creation: (Google_Pubsub_V1_Topic, CallOptions?) async throws -> Google_Pubsub_V1_Topic) async throws {
        let hashValue = rawValue.hashValue
        guard !verifiedHashValues.contains(hashValue) else {
            return
        }

        do {
            _ = try await creation(.with {
                $0.name = id
                $0.labels = labels
            }, nil)
        } catch {
            if !"\(error)".hasPrefix("already exists (6):") {
                throw error
            }
        }

        verifiedHashValues.append(hashValue)
    }
}
