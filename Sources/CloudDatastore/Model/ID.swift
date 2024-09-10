import Foundation

/// Identifier for `AnyKey`.
/// Can be an auto-allocated number ID, a named string ID or incomplete, future to be number ID.
public enum ID: Sendable, Hashable, Equatable, CustomStringConvertible, CustomDebugStringConvertible, Codable {

    /// Auto-allocated ID of a entity.
    /// Never equal to zero. Values less than zero are discouraged and may not be supported in the future.
    case uniq(Int64)

    /// Named id of a entity.
    /// A name matching regex `__.*__` is reserved/read-only.
    /// A name must not be more than 1500 bytes when UTF-8 encoded.
    /// Cannot be `""`.
    case named(String)

    /// Incomplete id of a entitiy which has not been created yet.
    /// When put into the datastore, the id of the entity is auto-allocated to an `.uniq(_)`.
    /// A parent key must not have a incomplete key.
    case incomplete

    /// Int64 (a.k.a. uniq) representation of the id.
    public var int64Value: Int64 {
        switch self {
        case .uniq(let value):
            return value
        case .named(let value):
            return Int64(value) ?? -1
        case .incomplete:
            return 0
        }
    }

    /// String (a.k.a. named) representation of the id.
    public var stringValue: String {
        switch self {
        case .named(let value):
            return value
        case .uniq(let value):
            return String(value)
        case .incomplete:
            return ""
        }
    }

    // MARK: - Encoding

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .uniq(let id):
            try container.encode(id)
        case .named(let id):
            try container.encode(id)
        case .incomplete:
            try container.encodeNil()
        }
    }

    var raw: Google_Datastore_V1_Key.PathElement.OneOf_IDType? {
        switch self {
        case .uniq(let id):
            return .id(id)
        case .named(let name):
            return .name(name)
        case .incomplete:
            return nil
        }
    }

    // MARK: - Decoding

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .uniq(try container.decode(Int64.self))
        } catch {
            do {
                self = .named(try container.decode(String.self))
            } catch {
                if container.decodeNil() {
                    self = .incomplete
                } else {
                    throw error
                }
            }
        }
    }

    init(raw: Google_Datastore_V1_Key.PathElement.OneOf_IDType?) {
        switch raw {
        case .id(let id):
            self = .uniq(id)
        case .name(let name):
            self = .named(name)
        case .none:
            self = .incomplete
        }
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        switch self {
        case .uniq(let value):
            return String(value)
        case .named(let value):
            return value
        case .incomplete:
            return ""
        }
    }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String {
        switch self {
        case .uniq(let value):
            return String(value)
        case .named(let value):
            return "\"\(value)\""
        case .incomplete:
            return "<incomplete>"
        }
    }
}
