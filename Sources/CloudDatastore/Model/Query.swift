import Foundation

public struct Query<Entity: _Entity>: Sendable {

    package var filters: [Google_Datastore_V1_PropertyFilter] = []
    package var orders: [Google_Datastore_V1_PropertyOrder] = []

    public var kind: String { Entity.Key.kind }
    public var namespace: Namespace
    public var limit: Int32?

    public init(_ type: Entity.Type, namespace: Namespace = .default, limit: Int32? = nil) {
        self.namespace = namespace
        self.limit = limit
    }

    // MARK: - Filtering

    public enum Condition {

        /// Equal: `==`
        case equals(QueryFilterValue)

        /// Less than: `<`
        case lessThan(QueryFilterValue)

        /// Less than or equal: `<=`
        case lessThanOrEqual(QueryFilterValue)

        /// Greater than: `>`
        case greaterThan(QueryFilterValue)

        /// Greater than or equal: `>=`
        case greaterThanOrEqual(QueryFilterValue)

        /// Has ancestor.
        case hasAncestor(QueryFilterValueKey)

        fileprivate var rawOp: Google_Datastore_V1_PropertyFilter.Operator {
            switch self {
            case .equals: return .equal
            case .lessThan: return .lessThan
            case .lessThanOrEqual: return .lessThanOrEqual
            case .greaterThan: return .greaterThan
            case .greaterThanOrEqual: return .greaterThanOrEqual
            case .hasAncestor: return .hasAncestor
            }
        }

        fileprivate var rawValue: Google_Datastore_V1_Value {
            switch self {
            case .equals(let value), .lessThan(let value), .lessThanOrEqual(let value), .greaterThan(let value), .greaterThanOrEqual(let value):
                return .with {
                    $0.valueType = (value._rawQueryFilterValue as! Google_Datastore_V1_Value.OneOf_ValueType)
                }
            case .hasAncestor(let value):
                return .with {
                    $0.valueType = (value._rawQueryFilterValue as! Google_Datastore_V1_Value.OneOf_ValueType)
                }
            }
        }
    }

    public mutating func filter(by key: Entity.CodingKeys, where condition: Condition) {
        filters.append(.with {
            $0.property = .with {
                if case .hasAncestor = condition {
                    $0.name = "__key__"
                } else {
                    $0.name = key.stringValue
                }
            }
            $0.op = condition.rawOp
            $0.value = condition.rawValue
        })
    }

    public func filtered(by key: Entity.CodingKeys, where condition: Condition) -> Self {
        var newQuery = self
        newQuery.filter(by: key, where: condition)
        return newQuery
    }

    // MARK: - Ordering

    public enum OrderDirection {
        case ascending, descending

        var raw: Google_Datastore_V1_PropertyOrder.Direction {
            switch self {
            case .ascending: return .ascending
            case .descending: return .descending
            }
        }
    }

    public mutating func order(by keys: [Entity.CodingKeys], direction: OrderDirection = .ascending) {
        orders.append(contentsOf: keys.map { key in
            .with {
                $0.property = .with {
                    $0.name = key.stringValue
                }
                $0.direction = direction.raw
            }
        })
    }

    public func ordered(by keys: [Entity.CodingKeys], direction: OrderDirection = .ascending) -> Self {
        var newQuery = self
        newQuery.order(by: keys, direction: direction)
        return newQuery
    }

    public mutating func order(by key: Entity.CodingKeys, direction: OrderDirection = .ascending) {
        order(by: [key], direction: direction)
    }

    public func ordered(by key: Entity.CodingKeys, direction: OrderDirection = .ascending) -> Self {
        var newQuery = self
        newQuery.order(by: key, direction: direction)
        return newQuery
    }
}

public protocol QueryFilterValue {

    var _rawQueryFilterValue: Any { get }
}

extension Bool: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.booleanValue(self)
    }
}

extension String: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.stringValue(self)
    }
}

extension Int: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension Int8: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension Int16: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension Int32: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension Int64: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(self)
    }
}

extension UInt: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension UInt8: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension UInt16: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension UInt32: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension UInt64: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.integerValue(Int64(self))
    }
}

extension Double: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.doubleValue(self)
    }
}

extension Float: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.doubleValue(Double(self))
    }
}

extension Date: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.timestampValue(.init(date: self))
    }
}

extension Data: QueryFilterValue {

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.blobValue(self)
    }
}

public protocol QueryFilterValueKey: QueryFilterValue {}
