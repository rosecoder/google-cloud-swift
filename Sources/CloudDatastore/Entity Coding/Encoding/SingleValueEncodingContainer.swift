import Foundation

extension EntityEncoder {

    final class SingleValueContainer: SingleValueEncodingContainer, Encoder, EncodingContainer {

        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any] = [:]

        init(codingPath: [CodingKey]) {
            self.codingPath = codingPath
        }

        var value: EncodingValue?

        var computedRaw: Google_Datastore_V1_Value {
            value?.computedRaw ?? .with { $0.valueType = .nullValue(.nullValue) }
        }

        // MARK: - SingleValueEncodingContainer

        func encodeNil() throws {
            value = .raw(.with { $0.valueType = .nullValue(.nullValue) })
        }

        func encode(_ value: Bool) throws {
            self.value = .raw(.with { $0.valueType = .booleanValue(value) })
        }

        func encode(_ value: String) throws {
            self.value = .raw(.with { $0.valueType = .stringValue(value) })
        }

        func encode(_ value: Double) throws {
            self.value = .raw(.with { $0.valueType = .doubleValue(value) })
        }

        func encode(_ value: Float) throws {
            self.value = .raw(.with { $0.valueType = .doubleValue(Double(value)) })
        }

        func encode(_ value: Int) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int8) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int16) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int32) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: Int64) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(value) })
        }

        func encode(_ value: UInt) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt8) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt16) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt32) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode(_ value: UInt64) throws {
            self.value = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        }

        func encode<T>(_ value: T) throws where T : Encodable {
            switch value {
            case let date as Date:
                self.value = .raw(.with { $0.valueType = .timestampValue(.init(date: date)) })

            case let data as Data:
                self.value = .raw(.with { $0.valueType = .blobValue(data) })

            case let key as _CodableKey:
                self.value = .raw(.with { $0.valueType = .keyValue(key.raw) })

            case let dictionary as Dictionary<AnyHashable, Encodable>:
                let properties: [String: Google_Datastore_V1_Value] = .init(uniqueKeysWithValues: try dictionary.map { key, value in
                    let stringKey = String(describing: key)
                    let valueContainer = SingleValueContainer(codingPath: codingPath + [NameKey(stringKey)])
                    try value.encode(to: valueContainer)
                    return (stringKey, valueContainer.computedRaw)
                })

                self.value = .raw(.with {
                    $0.valueType = .entityValue(.with {
                        $0.properties = properties
                    })
                })

            default:
                try value.encode(to: self)
            }
        }

        // MARK: - Encoder

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
            let container = KeyedContainer<Key>(codingPath: codingPath)
            value = .container(container)
            return KeyedEncodingContainer(container)
        }

        func unkeyedContainer() -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(codingPath: codingPath)
            value = .container(container)
            return container
        }

        func singleValueContainer() -> SingleValueEncodingContainer {
            self
        }
    }
}
