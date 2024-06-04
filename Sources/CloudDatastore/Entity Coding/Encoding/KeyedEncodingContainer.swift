import Foundation

protocol _EncodingContainer: AnyObject, EncodingContainer {

    var properties: [String: EncodingValue] { get set }
    var propertiesExcludedFromIndex: Set<String> { get set }
}

protocol _KeyedContainer<Key>: AnyObject, KeyedEncodingContainerProtocol, _EncodingContainer where Key: CodingKey {

    var codingPath: [CodingKey] { get }
    var propertyConfiguration: ((CodingKey) -> PropertyConfiguration)? { get }

    var properties: [String: EncodingValue] { get set }
    var propertiesExcludedFromIndex: Set<String> { get set }
}

extension _KeyedContainer {

    var computedRaw: Google_Datastore_V1_Value {
        .with {
            $0.valueType = .entityValue(.with {
                var properties = properties
                if let key = properties["___key"] {
                    $0.key = key.computedRaw.keyValue
                    properties.removeValue(forKey: "___key")
                }
                $0.properties = [:]
                $0.properties.reserveCapacity(properties.capacity)
                for (key, value) in properties {
                    var raw = value.computedRaw
                    raw.excludeFromIndexes = self.propertiesExcludedFromIndex.contains(key)
                    $0.properties[key] = raw
                }
            })
        }
    }

    // MARK: - Nested containers

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        let container = EntityEncoder.KeyedContainer<NestedKey>(codingPath: codingPath)
        properties[key.stringValue] = .container(container)
        return KeyedEncodingContainer(container)
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let container = EntityEncoder.UnkeyedContainer(codingPath: codingPath)
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

    private func encodeExcludedFromIndex(key: Key) {
        if propertyConfiguration?(key).excludeFromIndexes == true {
            propertiesExcludedFromIndex.insert(key.stringValue)
        }
    }

    func encodeNil(forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .nullValue(.nullValue) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .booleanValue(value) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: String, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .stringValue(value) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Double, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .doubleValue(value) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Float, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .doubleValue(Double(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Int, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Int8, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Int16, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Int32, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: Int64, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: UInt, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
        properties[key.stringValue] = .raw(.with { $0.valueType = .integerValue(Int64(value)) })
        encodeExcludedFromIndex(key: key)
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        if key.stringValue == "key" {
            precondition(value is _CodableKey)
            properties["___key"] = .raw(.with { $0.valueType = .keyValue((value as! _CodableKey).raw) })
            return
        }

        let container = EntityEncoder.SingleValueContainer(codingPath: codingPath + [key])
        try container.encode(value)
        properties[key.stringValue] = .container(container)
        encodeExcludedFromIndex(key: key)
    }
}

extension EntityEncoder {

    final class KeyedContainer<Key>: _KeyedContainer where Key: CodingKey {

        let codingPath: [CodingKey]
        let propertyConfiguration: ((CodingKey) -> PropertyConfiguration)?

        init(
            codingPath: [CodingKey],
            propertyConfiguration: ((CodingKey) -> PropertyConfiguration)? = nil
        ) {
            self.codingPath = codingPath
            self.propertyConfiguration = propertyConfiguration
        }

        var properties: [String: EncodingValue] = [:]
        var propertiesExcludedFromIndex = Set<String>()
    }

    final class ReferncedKeyedContainer<Key>: _KeyedContainer where Key: CodingKey {

        let codingPath: [CodingKey]
        let propertyConfiguration: ((CodingKey) -> PropertyConfiguration)?

        init(
            codingPath: [CodingKey],
            propertyConfiguration: ((CodingKey) -> PropertyConfiguration)?,
            propertiesReference: UnsafeMutablePointer<[String: EncodingValue]>,
            propertiesExcludedFromIndexReference: UnsafeMutablePointer<Set<String>>
        ) {
            self.codingPath = codingPath
            self.propertyConfiguration = propertyConfiguration
            self.propertiesReference = propertiesReference
            self.propertiesExcludedFromIndexReference = propertiesExcludedFromIndexReference
        }

        let propertiesReference: UnsafeMutablePointer<[String: EncodingValue]>
        let propertiesExcludedFromIndexReference: UnsafeMutablePointer<Set<String>>

        var properties: [String: EncodingValue] {
            get { propertiesReference.pointee }
            set { propertiesReference.pointee = newValue }
        }
        var propertiesExcludedFromIndex: Set<String> {
            get { propertiesExcludedFromIndexReference.pointee }
            set { propertiesExcludedFromIndexReference.pointee = newValue }
        }
    }
}
