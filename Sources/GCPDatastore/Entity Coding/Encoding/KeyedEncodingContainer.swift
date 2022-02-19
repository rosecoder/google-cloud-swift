import Foundation

extension EntityEncoder {

    final class KeyedContainer<Key>: KeyedEncodingContainerProtocol, EncodingContainer where Key: CodingKey {

        let codingPath: [CodingKey]

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        var properties: [String: EncodingValue] = [:]

        var computedRaw: Google_Datastore_V1_Value {
            .with {
                $0.valueType = .entityValue(.with {
                    var properties = properties
                    if let key = properties["___key"] {
                        $0.key = key.computedRaw.keyValue
                        properties.removeValue(forKey: "___key")
                    }
                    $0.properties = properties.mapValues { $0.computedRaw }
                })
            }
        }

        // MARK: - Nested containers

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            let container = KeyedContainer<NestedKey>(codingPath: codingPath)
            properties[key.stringValue] = .container(container)
            return KeyedEncodingContainer(container)
        }

        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(codingPath: codingPath)
            properties[key.stringValue] = .container(container)
            return container
        }

        // MARK: - Encoder

        func superEncoder() -> Encoder {
            fatalError("\(#function) has not been implemented")
        }

        func superEncoder(forKey key: Key) -> Encoder {
            fatalError("\(#function) has not been implemented")
        }

        // MARK: - Encode

        func encodeNil(forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .nullValue(.nullValue) })
        }

        func encode(_ value: Bool, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .booleanValue(value) })
        }

        func encode(_ value: String, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .stringValue(value) })
        }

        func encode(_ value: Double, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .doubleValue(value) })
        }

        func encode(_ value: Float, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .doubleValue(Double(value)) })
        }

        func encode(_ value: Int, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int8, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int16, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int32, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int64, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt8, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt16, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt32, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt64, forKey key: Key) throws {
            properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
            if key.stringValue == "key" {
                precondition(value is _CodableKey)
                properties["___key"] = .raw(.with { $0.valueType = .keyValue((value as! _CodableKey).raw) })
                return
            }

            let container = SingleValueContainer(codingPath: codingPath + [key])
            try container.encode(value)
            properties[key.stringValue] = .container(container)
        }
    }
}
