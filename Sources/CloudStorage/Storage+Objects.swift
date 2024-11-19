import Foundation
import Tracing

extension Storage {

    // MARK: - Insert

    public func insert(data: Data, contentType: String, object: Object, in bucket: Bucket) async throws {
#if DEBUG
        guard !isUsingLocalStorage else {
            let url = object.localStorageURL(in: bucket)
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: url)
            return
        }
#endif

        try await withSpan("storage-insert", ofKind: .client) { span in
            span.attributes["storage/bucket"] = bucket.name
            try await execute(
                method: .POST,
                path: "/upload/storage/v1/b/\(bucket.urlEncoded)/o",
                queryItems: [
                    .init(name: "uploadType", value: "media"),
                    .init(name: "name", value: object.path),
                ],
                headers: [
                    "Content-Type": contentType,
                    "Content-Length": String(data.count),
                ],
                body: .bytes(data)
            )
        }
    }

    // MARK: - Delete

    public func delete(object: Object, in bucket: Bucket) async throws {
#if DEBUG
        guard !isUsingLocalStorage else {
            let url = object.localStorageURL(in: bucket)
            try FileManager.default.removeItem(at: url)
            return
        }
#endif

        try await withSpan("storage-delete", ofKind: .client) { span in
            span.attributes["storage/bucket"] = bucket.name
            try await execute(
                method: .DELETE,
                path: "/storage/v1/b/\(bucket.urlEncoded)/o/\(object.urlEncoded)"   
            )
        }
    }
}
