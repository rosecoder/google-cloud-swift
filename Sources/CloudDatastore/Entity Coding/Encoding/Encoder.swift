import Foundation

struct EntityEncoder {

    func encode<T>(_ value: T) throws -> Google_Datastore_V1_Entity
    where T: Entity,
          T.Key: AnyKey
    {
        let encoder = RootEncoder(propertyConfiguration: {
            ($0 as? T.CodingKeys).flatMap { T.propertyConfiguration(key: $0) } ?? T.propertyConfiguration(otherKey: $0)
        })
        try value.encode(to: encoder)
        return encoder.container!.computedRaw.entityValue
    }

    final private class RootEncoder: Encoder {

        let propertyConfiguration: (CodingKey) -> PropertyConfiguration

        let codingPath: [CodingKey] = []
        let userInfo: [CodingUserInfoKey: Any] = [:]

        init(propertyConfiguration: @escaping ((CodingKey) -> PropertyConfiguration)) {
            self.propertyConfiguration = propertyConfiguration
        }

        var container: _EncodingContainer?

        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
            if let primaryContainer = container {
                let referencedContainer = ReferncedKeyedContainer<Key>(
                    codingPath: codingPath,
                    propertyConfiguration: propertyConfiguration,
                    propertiesReference: &primaryContainer.properties,
                    propertiesExcludedFromIndexReference: &primaryContainer.propertiesExcludedFromIndex
                )
                return KeyedEncodingContainer(referencedContainer)
            }

            let container = KeyedContainer<Key>(codingPath: codingPath, propertyConfiguration: propertyConfiguration)
            self.container = container
            return KeyedEncodingContainer(container)
        }

        func unkeyedContainer() -> UnkeyedEncodingContainer {
            fatalError("Root entity must be encoded as keyed container")
        }

        func singleValueContainer() -> SingleValueEncodingContainer {
            fatalError("Root entity must be encoded as keyed container")
        }
    }
}
