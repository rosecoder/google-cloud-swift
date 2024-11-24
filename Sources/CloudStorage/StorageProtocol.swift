import Foundation

public protocol StorageProtocol: Sendable {

    func insert(
        data: Data,
        contentType: String,
        object: Object,
        in bucket: Bucket
    ) async throws

    func delete(object: Object, in bucket: Bucket) async throws

    func generateSignedURL(
        for action: SignedAction,
        expiration: TimeInterval,
        object: Object,
        in bucket: Bucket
    ) async throws -> String
}

public enum SignedAction {
    case reading
    case writing
}

extension StorageProtocol {

    public func generateSignedURL(
        for action: SignedAction,
        expiration: TimeInterval = Storage.signedURLMaximumExpirationDuration,
        object: Object,
        in bucket: Bucket
    ) async throws -> String {
        try await generateSignedURL(for: action, expiration: expiration, object: object, in: bucket)
    }
}
