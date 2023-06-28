import Foundation

extension EntityDecoder {

    struct SingleValueContainer: SingleValueDecodingContainer, Decoder {

        let codingPath: [CodingKey]
        let userInfo: [CodingUserInfoKey: Any] = [:]

        // MARK: - SingleValueDecodingContainer

        let raw: Google_Datastore_V1_Value?

        private var valueType: Google_Datastore_V1_Value.OneOf_ValueType {
            raw?.valueType ?? .nullValue(.nullValue)
        }

        func decodeNil() -> Bool {
            valueType == .nullValue(.nullValue)
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            switch valueType {
            case .booleanValue(let value): return value
            case .nullValue: return false
            case .integerValue(let value): return value > 0
            case .doubleValue(let value): return value > 0
            case .stringValue(let value): return !value.isEmpty
            case .timestampValue(let value): return value.seconds != 0 || value.nanos != 0
            case .geoPointValue(let value): return value.latitude != 0 || value.longitude != 0
            default: throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func decode(_ type: String.Type) throws -> String {
            switch valueType {
            case .stringValue(let value): return value
            case .booleanValue(let value): return value ? "true" : "false"
            case .nullValue: return ""
            case .integerValue(let value): return String(value)
            case .doubleValue(let value): return String(value)
            default: throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func decode(_ type: Double.Type) throws -> Double {
            switch valueType {
            case .doubleValue(let value): return value
            case .integerValue(let value): return Double(value)
            case .nullValue: return 0
            case .timestampValue(let value): return value.timeIntervalSince1970
            case .stringValue(let value):
                guard let parsed = Double(value) else {
                    throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                }
                return parsed
            case .booleanValue(let value): return value ? 1 : 0
            default: throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func decode(_ type: Float.Type) throws -> Float {
            switch valueType {
            case .doubleValue(let value): return Float(value)
            case .integerValue(let value): return Float(value)
            case .nullValue: return 0
            case .timestampValue(let value): return Float(value.timeIntervalSince1970)
            case .stringValue(let value):
                guard let parsed = Float(value) else {
                    throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                }
                return parsed
            case .booleanValue(let value): return value ? 1 : 0
            default: throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func decode(_ type: Int.Type) throws -> Int {
            Int(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            Int8(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            Int16(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            Int32(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            switch valueType {
            case .integerValue(let value): return value
            case .doubleValue(let value): return Int64(value)
            case .nullValue: return 0
            case .timestampValue(let value): return Int64(value.timeIntervalSince1970)
            case .stringValue(let value):
                guard let parsed = Int64(value) else {
                    throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                }
                return parsed
            case .booleanValue(let value): return value ? 1 : 0
            default: throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            UInt(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            UInt8(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            UInt16(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            UInt32(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            UInt64(try decode(Int64.self)) // TODO: Add bounds check
        }

        func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            switch type {
            case is Date.Type:
                let returning: Date
                switch valueType {
                case .timestampValue(let value):
                    returning = value.date
                case .doubleValue(let value):
                    returning = Date(timeIntervalSince1970: value)
                case .integerValue(let value):
                    returning = Date(timeIntervalSince1970: Double(value))
                case .nullValue:
                    returning = Date(timeIntervalSince1970: 0)
                default:
                    throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                }
                return returning as! T

            case is Data.Type:
                let returning: Data
                switch valueType {
                case .blobValue(let value):
                    returning = value
                case .stringValue(let value):
                    guard let data = value.data(using: .utf8) else {
                        throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                    }
                    returning = data
//                case .doubleValue(let value):
//                    // TODO: Implement
//                case .integerValue(let value):
//                    // TODO: Implement
                case .booleanValue(let value):
                    returning = value ? Data([1]) : Data([0])
                case .nullValue:
                    returning = Data()
                default:
                    throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                }
                return returning as! T

            case is _CodableKey:
                let returning: _CodableKey
                switch valueType {
                case .keyValue(let value):
                    returning = (T.self as! _CodableKey.Type).init(raw: value)
                default:
                    throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
                }
                return returning as! T

            default:
                return try T.init(from: self)
            }
        }

        // MARK: - Decoder

        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            switch valueType {
            case .entityValue(let entity):
                return KeyedDecodingContainer(KeyedContainer<Key>(
                    codingPath: codingPath,
                    key: entity.key,
                    properties: entity.properties
                ))
            default:
                throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            switch valueType {
            case .arrayValue(let array):
                return UnkeyedContainer(
                    codingPath: codingPath,
                    values: array.values
                )
            case .entityValue(let entity):
                // TODO: Replace the following with a custom UnkeyedDecodingContainer
                // The following is a bit slow due to the convertion each key.

                var values = [Google_Datastore_V1_Value]()
                values.reserveCapacity(entity.properties.count * 2)
                for (key, value) in entity.properties {
                    values.append(contentsOf: [
                        .with { $0.valueType = .stringValue(key) },
                        value,
                    ])
                }
                return UnkeyedContainer(codingPath: codingPath, values: values)
            default:
                throw UndecodableTypeError(codingPath: codingPath, expectedType: valueType)
            }
        }

        func singleValueContainer() throws -> SingleValueDecodingContainer {
            self
        }
    }
}
