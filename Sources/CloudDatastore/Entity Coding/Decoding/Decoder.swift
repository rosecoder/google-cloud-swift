import Foundation

struct EntityDecoder {

    struct UndecodableTypeError: Error {

        let codingPath: [CodingKey]
        let expectedType: Google_Datastore_V1_Value.OneOf_ValueType?
    }

    func decode<T>(_ type: T.Type, from raw: Google_Datastore_V1_Entity) throws -> T
    where T: Decodable & Entity,
          T.Key: AnyKey
    {
        try T.init(from: _Decoder(raw: raw))
    }

    private struct _Decoder: Decoder {

        var codingPath: [CodingKey] { [] }
        var userInfo: [CodingUserInfoKey: Any] { [:] }

        let raw: Google_Datastore_V1_Entity

        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            KeyedDecodingContainer(KeyedContainer<Key>(
                codingPath: codingPath,
                key: raw.key,
                properties: raw.properties
            ))
        }

        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError("Root entity must be decoded as keyed container")
        }

        func singleValueContainer() throws -> SingleValueDecodingContainer {
            fatalError("Root entity must be decoded as keyed container")
        }
    }
}
