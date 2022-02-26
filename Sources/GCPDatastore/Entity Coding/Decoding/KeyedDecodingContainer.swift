import Foundation

extension EntityDecoder {

    struct KeyedContainer<Key>: KeyedDecodingContainerProtocol where Key: CodingKey {

        let codingPath: [CodingKey]

        let key: Google_Datastore_V1_Key?
        let properties: [String: Google_Datastore_V1_Value]

        // MARK: - Nested containers

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey
        {
            let valueType = properties[key.stringValue]?.valueType
            switch valueType {
            case .entityValue(let entity):
                return KeyedDecodingContainer(KeyedContainer<NestedKey>(
                    codingPath: codingPath + [key],
                    key: entity.key,
                    properties: entity.properties
                ))
            default:
                throw UndecodableTypeError(codingPath: codingPath + [key], expectedType: valueType)
            }
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            let valueType = properties[key.stringValue]?.valueType
            switch valueType {
            case .arrayValue(let array):
                return UnkeyedContainer(
                    codingPath: codingPath + [key],
                    values: array.values
                )
            default:
                throw UndecodableTypeError(codingPath: codingPath + [key], expectedType: valueType)
            }
        }

        // MARK: - Decoder

        func superDecoder() throws -> Decoder {
            fatalError("\(#function) has not been implemented")
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError("\(#function) has not been implemented")
        }

        // MARK: - Decode

        var allKeys: [Key] {
            properties.keys.map { Key.init(stringValue: $0)! }
        }

        func contains(_ key: Key) -> Bool {
            properties.keys.contains(key.stringValue)
        }

        private func singleValueContainer(forKey key: Key) throws -> SingleValueContainer {
            SingleValueContainer(
                codingPath: codingPath + [key],
                raw: properties[key.stringValue]
            )
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            try singleValueContainer(forKey: key).decodeNil()
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            try singleValueContainer(forKey: key).decode(Bool.self)
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            try singleValueContainer(forKey: key).decode(String.self)
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            try singleValueContainer(forKey: key).decode(Double.self)
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            try singleValueContainer(forKey: key).decode(Float.self)
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            try singleValueContainer(forKey: key).decode(Int.self)
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            try singleValueContainer(forKey: key).decode(Int8.self)
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            try singleValueContainer(forKey: key).decode(Int16.self)
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            try singleValueContainer(forKey: key).decode(Int32.self)
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            try singleValueContainer(forKey: key).decode(Int64.self)
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            try singleValueContainer(forKey: key).decode(UInt.self)
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            try singleValueContainer(forKey: key).decode(UInt8.self)
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            try singleValueContainer(forKey: key).decode(UInt16.self)
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            try singleValueContainer(forKey: key).decode(UInt32.self)
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            try singleValueContainer(forKey: key).decode(UInt64.self)
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            if key.stringValue == "key", let key = self.key {
                precondition(type is _CodableKey.Type)
                return (T.self as! _CodableKey.Type).init(raw: key) as! T
            }

            return try singleValueContainer(forKey: key).decode(type)
        }
    }
}
