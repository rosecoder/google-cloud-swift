import Foundation
import GCPTrace

extension Storage {

    public static func delete(object: Object, in bucket: Bucket, context: Context) async throws {
        try await execute(method: .DELETE, path: "/b/\(bucket.urlEncoded)/o/\(object.urlEncoded)", context: context)
    }
}
