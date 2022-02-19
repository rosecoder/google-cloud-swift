import Foundation

struct EntityEncoder {

    func encode<T>(_ value: T) throws -> Google_Datastore_V1_Entity
    where T: Entity,
          T.Key: AnyKey
    {
        let encoder = RootEncoder()
        try value.encode(to: encoder)
        return encoder.container!.computedRaw.entityValue
    }

    final private class RootEncoder: Encoder {

        let codingPath: [CodingKey] = []
        let userInfo: [CodingUserInfoKey: Any] = [:]

        var container: EncodingContainer?

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
            assert(container == nil)

            let container = KeyedContainer<Key>(codingPath: codingPath)
            self.container = container
            return KeyedEncodingContainer(container)
        }

        func unkeyedContainer() -> UnkeyedEncodingContainer {
            fatalError("Root entity must be encoded as keyed container")
        }

        func singleValueContainer() -> SingleValueEncodingContainer {
            fatalError("Root entity must be encoded as keyed container")
        }
    }
}
