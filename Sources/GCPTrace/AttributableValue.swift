import Foundation

/// Value for a span attributes.
///
/// Never implement this protocol for your own types. It's just used for type safety on supporting types.
public protocol AttributableValue {

    var _gcpTraceRawValue: Any { get }

    var _codableValue: AttributableValueCodableValue { get }
}

public enum AttributableValueCodableValue: Equatable, Codable {
    case string(String)
    case int(Int64)
    case bool(Bool)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        }
    }

    public struct InvalidRepresentationError: Error {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .string(try container.decode(String.self))
        } catch {
            do {
                self = .int(try container.decode(Int64.self))
            } catch {
                do {
                    self = .bool(try container.decode(Bool.self))
                } catch {
                    throw InvalidRepresentationError()
                }
            }
        }
    }

    var attributableValue: AttributableValue {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return value
        case .bool(let value):
            return value
        }
    }
}

// MARK: - Supported Base Types

extension String: AttributableValue {

    public var _gcpTraceRawValue: Any {
        Google_Devtools_Cloudtrace_V2_AttributeValue.with {
            $0.stringValue = Google_Devtools_Cloudtrace_V2_TruncatableString(self, limit: 256)
        }
    }

    public var _codableValue: AttributableValueCodableValue { .string(self) }
}

extension Int64: AttributableValue {

    public var _gcpTraceRawValue: Any {
        Google_Devtools_Cloudtrace_V2_AttributeValue.with {
            $0.intValue = self
        }
    }

    public var _codableValue: AttributableValueCodableValue { .int(self) }
}

extension Bool: AttributableValue {

    public var _gcpTraceRawValue: Any {
        Google_Devtools_Cloudtrace_V2_AttributeValue.with {
            $0.boolValue = self
        }
    }

    public var _codableValue: AttributableValueCodableValue { .bool(self) }
}

// MARK: - Convenience Supported Types

extension Int: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
extension Int8: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
extension Int16: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
extension Int32: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
extension UInt8: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
extension UInt16: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
extension UInt32: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
    public var _codableValue: AttributableValueCodableValue { .int(Int64(self)) }
}
