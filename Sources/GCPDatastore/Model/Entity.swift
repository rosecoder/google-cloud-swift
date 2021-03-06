public protocol Entity: Codable, QueryFilterValue {

    associatedtype Key
    associatedtype CodingKeys

    /// Entity key property identifying the entity.
    ///
    /// **Important**: When using custom `CodingKeys`, make sure this property is encoded to `"key"`.
    ///
    /// Note: Must be mutating for new key to be set after a put/insert/update-operation.
    var key: Key { get set }

    var propertyConfigurations: [String: PropertyConfiguration] { get }
}

extension Entity {

    public var propertyConfigurations: [String: PropertyConfiguration] { [:] }
}

extension Entity where Key: AnyKey {

    public var _rawQueryFilterValue: Any {
        let encoder = EntityEncoder()
        return Google_Datastore_V1_Value.OneOf_ValueType.entityValue(
            try! encoder.encode(self)
        )
    }
}
