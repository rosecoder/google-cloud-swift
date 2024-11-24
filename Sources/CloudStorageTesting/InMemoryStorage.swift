import CloudStorage
import Foundation
import Synchronization

public final class InMemoryStorage: StorageProtocol {

    private let objects = Mutex<[String: Data]>([:])

    public init() {}

    private func key(object: Object, in bucket: Bucket) -> String {
        bucket.name + "/" + object.path
    }

    public func insert(data: Data, contentType: String, object: Object, in bucket: Bucket) {
        objects.withLock {
            $0[key(object: object, in: bucket)] = data
        }
    }
    
    public func delete(object: Object, in bucket: Bucket) {
        _ = objects.withLock {
            $0.removeValue(forKey: key(object: object, in: bucket))
        }
    }
}
