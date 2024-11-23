import CloudDatastore

extension FakeDatastore {

    // MARK: - By Key

    public func deleteEntities<Key: AnyKey>(
        keys: [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws {
        for key in keys {
            storage.removeValue(forKey: storageKey(fromEntityKey: key))
        }
    }

    public func deleteEntity<Key: AnyKey>(
        key: Key,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        try await deleteEntities(keys: [key], file: file, function: function, line: line)
    }

    // MARK: - By Entity

    public func delete<Entity: _Entity>(
        entities: [Entity],
        file: String,
        function: String,
        line: UInt
    ) async throws {
        try await deleteEntities(keys: entities.map({ $0.key}), file: file, function: function, line: line)
    }

    public func delete<Entity: _Entity>(
        _ entity: Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        try await deleteEntity(key: entity.key, file: file, function: function, line: line)
    }

    // MARK: - By Query

    public func deleteEntities<Entity: _Entity>(
        query: Query<Entity>,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        let keys = try await getKeys(query: query, file: file, function: function, line: line)
        if !keys.isEmpty {
            try await deleteEntities(keys: keys, file: file, function: function, line: line)
        }
    }
}
