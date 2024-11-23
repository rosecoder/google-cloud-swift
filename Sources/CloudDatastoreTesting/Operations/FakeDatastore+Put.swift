import CloudDatastore

extension FakeDatastore {

    public func put<Entity: _Entity>(
        entities: inout [Entity],
        file: String,
        function: String,
        line: UInt
    ) async throws {
        let keysAndData = try entities.map { ($0.key, try encoder.encode($0)) }
        for (index, (key, data)) in keysAndData.enumerated() {
            var key = key
            if key.id == .incomplete {
                try await allocateID(&key, file: file, function: function, line: line)
                entities[index].key = key
            }
            storage[storageKey(fromEntityKey: key)] = data
        }
    }

    public func put<Entity: _Entity>(
        entity: inout Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        var entities = [entity]
        try await put(entities: &entities, file: file, function: function, line: line)
        entity = entities[0]
    }

    public func allocateIDs<Key: AnyKey>(
        _ keys: inout [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws {
        for index in keys.indices {
            try await allocateID(&keys[index], file: file, function: function, line: line)
        }
    }

    public func allocateID<Key: AnyKey>(
        _ key: inout Key,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        precondition(key.id == .incomplete)

        key = .init(nextElement: {
            allocatedIDsCounter += 1
            return Google_Datastore_V1_Key.PathElement.with {
                $0.kind = Key.kind
                $0.idType = .id(allocatedIDsCounter)
            }
        }, namespace: key.namespace)
    }

    public func allocateKey<Key: IndependentKey>(
        _ keyType: Key.Type,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Key {
        var keys = [Key.init(id: .incomplete)]
        try await allocateIDs(&keys, file: file, function: function, line: line)
        return keys[0]
    }

    public func allocateKey<Key: IndependentNamespaceableKey>(
        _ keyType: Key.Type,
        namespace: Namespace,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Key {
        var keys = [Key.init(id: .incomplete, namespace: namespace)]
        try await allocateIDs(&keys, file: file, function: function, line: line)
        return keys[0]
    }
}
