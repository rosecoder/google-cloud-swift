import Foundation
import GCPTrace

extension Storage {

    // MARK: - Insert

    public static func insert(data: Data, contentType: String, object: Object, in bucket: Bucket, context: Context) async throws {
        try await context.trace.recordSpan(named: "storage-insert", kind: .client, attributes: [
            "storage/bucket": bucket.name,
        ]) { span in
            try await execute(
                method: .POST,
                path: "/upload/storage/v1/b/\(bucket.urlEncoded)/o",
                queryItems: [
                    .init(name: "uploadType", value: "media"),
                    .init(name: "name", value: object.urlEncoded),
                ],
                headers: [
                    "Content-Type": contentType,
                    "Content-Length": String(data.count),
                ],
                body: .bytes(data),
                context: context
            )
        }
    }

    // MARK: - Delete

    public static func delete(object: Object, in bucket: Bucket, context: Context) async throws {
        try await context.trace.recordSpan(named: "storage-delete", kind: .client, attributes: [
            "storage/bucket": bucket.name,
        ]) { span in
            try await execute(
                method: .DELETE,
                path: "/storage/v1/b/\(bucket.urlEncoded)/o/\(object.urlEncoded)",
                context: context
            )
        }
    }
}
