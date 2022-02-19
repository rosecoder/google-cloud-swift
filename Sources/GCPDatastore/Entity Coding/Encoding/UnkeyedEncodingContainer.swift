import Foundation

extension EntityEncoder {

    final class UnkeyedContainer: UnkeyedEncodingContainer, EncodingContainer {

        let codingPath: [CodingKey]

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        var values: [EncodingValue] = []

        var count: Int { values.count }

        var computedRaw: Google_Datastore_V1_Value {
            .with {
                $0.valueType = .arrayValue(.with {
                    $0.values = self.values.map { $0.computedRaw }
                })
            }
        }

        // MARK: - Nested containers

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            let container = KeyedContainer<NestedKey>(codingPath: codingPath + [IndexKey(values.count)])
            values.append(.container(container))
            return KeyedEncodingContainer(container)
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(codingPath: codingPath + [IndexKey(values.count)])
            values.append(.container(container))
            return container
        }

        // MARK: - Encoder

        func superEncoder() -> Encoder {
            fatalError("\(#function) has not been implemented")
        }

        // MARK: - Encode

        func encodeNil() throws {
            values.append(.raw(.with { $0.valueType = .nullValue(.nullValue) }))
        }

        func encode(_ value: Bool) throws {
            values.append(.raw(.with { $0.valueType = .booleanValue(value) }))
        }

        func encode(_ value: String) throws {
            values.append(.raw(.with { $0.valueType = .stringValue(value) }))
        }

        func encode(_ value: Double) throws {
            values.append(.raw(.with { $0.valueType = .doubleValue(value) }))
        }

        func encode(_ value: Float) throws {
            values.append(.raw(.with { $0.valueType = .doubleValue(Double(value)) }))
        }

        func encode(_ value: Int) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: Int8) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: Int16) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: Int32) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: Int64) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(value) }))
        }

        func encode(_ value: UInt) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: UInt8) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: UInt16) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: UInt32) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode(_ value: UInt64) throws {
            values.append(.raw(.with { $0.valueType = .integerValue(Int64(value)) }))
        }

        func encode<T>(_ value: T) throws where T: Encodable {
            let container = SingleValueContainer(codingPath: codingPath + [IndexKey(values.count)])
            try container.encode(value)
            values.append(.container(container))
        }
    }
}

