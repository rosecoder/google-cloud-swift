import Foundation
import CloudDatastore

public actor FakeDatastore: DatastoreProtocol {

    public init() {}

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var storage = [String: Data]()

    var allocatedIDsCounter: Int64 = 0

    func storageKey<Key: AnyKey>(fromEntityKey key: Key) -> String {
        key.debugDescription
    }

    func storageKeys<Key: AnyKey>(fromEntityKeys keys: [Key]) -> [String] {
        keys.map { storageKey(fromEntityKey: $0) }
    }
}
