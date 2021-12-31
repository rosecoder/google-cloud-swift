import Foundation
import GRPC

public struct Topic: Identifiable, Equatable, Hashable {

    public let name: String

    public let labels: [String: String]

    public init(name: String, labels: [String: String] = [:]) {
        self.name = name
        self.labels = labels
    }

    // MARK: - Identifiable

    public var id: String {
        "projects/\(ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] ?? "")/topics/\(name)"
    }

    // MARK: - Hashable

    public var rawValue: String {
        id
    }

    // MARK: - Creation

    private static var verifiedHashValues = [Int]()

    func createIfNeeded(creation: (Google_Pubsub_V1_Topic, CallOptions?) async throws -> Google_Pubsub_V1_Topic) async throws {
        let hashValue = rawValue.hashValue
        guard !Self.verifiedHashValues.contains(hashValue) else {
            return
        }

        do {
            _ = try await creation(.with {
                $0.name = id
                $0.labels = labels
            }, nil)
        } catch {
            if !"\(error)".hasPrefix("alreadyExists (6):") {
                throw error
            }
        }

        Self.verifiedHashValues.append(hashValue)
    }
}
