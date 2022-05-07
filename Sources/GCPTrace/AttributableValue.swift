import Foundation

/// Value for a span attributes.
///
/// Never implement this protocol for your own types. It's just used for type safety on supporting types.
public protocol AttributableValue {

    var _gcpTraceRawValue: Any { get }
}

// MARK: - Supported Base Types

extension String: AttributableValue {

    public var _gcpTraceRawValue: Any {
        Google_Devtools_Cloudtrace_V2_AttributeValue.with {
            $0.stringValue = Google_Devtools_Cloudtrace_V2_TruncatableString(self, limit: 256)
        }
    }
}

extension Int64: AttributableValue {

    public var _gcpTraceRawValue: Any {
        Google_Devtools_Cloudtrace_V2_AttributeValue.with {
            $0.intValue = self
        }
    }
}

extension Bool: AttributableValue {

    public var _gcpTraceRawValue: Any {
        Google_Devtools_Cloudtrace_V2_AttributeValue.with {
            $0.boolValue = self
        }
    }
}

// MARK: - Convenience Supported Types

extension Int: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
extension Int8: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
extension Int16: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
extension Int32: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
extension UInt8: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
extension UInt16: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
extension UInt32: AttributableValue {
    public var _gcpTraceRawValue: Any { Int64(self)._gcpTraceRawValue }
}
