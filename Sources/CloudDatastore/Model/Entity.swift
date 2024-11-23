public typealias _Entity = Entity

public protocol Entity: Sendable, Codable, QueryFilterValue {
    
    associatedtype Key: AnyKey
    associatedtype CodingKeys: CodingKey

    /// Entity key property identifying the entity.
    ///
    /// **Important**: When using custom `CodingKeys`, make sure this property is encoded to `"key"`.
    ///
    /// Note: Must be mutating for new key to be set after a put/insert/update-operation.
    var key: Key { get set }
    
    static func propertyConfiguration(key: CodingKeys) -> PropertyConfiguration
    static func propertyConfiguration(otherKey: any CodingKey) -> PropertyConfiguration
}

extension Entity {

    public static func propertyConfiguration(key: CodingKeys) -> PropertyConfiguration {
        .init()
    }

    public static func propertyConfiguration(otherKey: any CodingKey) -> PropertyConfiguration {
        .init()
    }
}

extension Entity {

    public var _rawQueryFilterValue: Any {
        let encoder = EntityEncoder()
        return Google_Datastore_V1_Value.OneOf_ValueType.entityValue(
            try! encoder.encode(self)
        )
    }
}
