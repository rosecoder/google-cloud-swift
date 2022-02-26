import Foundation

extension EntityDecoder {

    struct UnkeyedContainer: UnkeyedDecodingContainer {

        let codingPath: [CodingKey]

        let values: [Google_Datastore_V1_Value]

        var currentIndex: Int = 0

        var count: Int? { values.count }

        var isAtEnd: Bool { currentIndex >= values.count }

        private mutating func nextValue() -> Google_Datastore_V1_Value {
            precondition(!isAtEnd)

            defer { currentIndex += 1 }
            return values[currentIndex]
        }

        // MARK: - Nested containers

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
            let valueType = nextValue().valueType
            switch valueType {
            case .entityValue(let entity):
                return KeyedDecodingContainer(KeyedContainer<NestedKey>(
                    codingPath: codingPath + [IndexKey(currentIndex)],
                    key: entity.key,
                    properties: entity.properties
                ))
            default:
                currentIndex -= 1
                throw UndecodableTypeError(codingPath: codingPath + [IndexKey(currentIndex)], expectedType: valueType)
            }
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let valueType = nextValue().valueType
            switch valueType {
            case .arrayValue(let array):
                return UnkeyedContainer(
                    codingPath: codingPath + [IndexKey(currentIndex)],
                    values: array.values
                )
            default:
                currentIndex -= 1
                throw UndecodableTypeError(codingPath: codingPath + [IndexKey(currentIndex)], expectedType: valueType)
            }
        }

        // MARK: - Decoder

        mutating func superDecoder() throws -> Decoder {
            fatalError("\(#function) has not been implemented")
        }

        // MARK: - Decoding

        mutating func decodeNil() throws -> Bool {
            SingleValueContainer(codingPath: codingPath, raw: nextValue()).decodeNil()
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Bool.self)
        }

        mutating func decode(_ type: String.Type) throws -> String {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(String.self)
        }

        mutating func decode(_ type: Double.Type) throws -> Double {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Double.self)
        }

        mutating func decode(_ type: Float.Type) throws -> Float {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Float.self)
        }

        mutating func decode(_ type: Int.Type) throws -> Int {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Int.self)
        }

        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Int8.self)
        }

        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Int16.self)
        }

        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Int32.self)
        }

        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(Int64.self)
        }

        mutating func decode(_ type: UInt.Type) throws -> UInt {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(UInt.self)
        }

        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(UInt8.self)
        }

        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(UInt16.self)
        }

        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(UInt32.self)
        }

        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(UInt64.self)
        }

        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            try SingleValueContainer(codingPath: codingPath, raw: nextValue()).decode(T.self)
        }
    }
}
