import CloudDatastore

extension FakeDatastore {

    public func getEntities<Entity: _Entity>(
        keys: [Entity.Key],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity?] {
        let data = storageKeys(fromEntityKeys: keys).map { storage[$0] }
        return try data.enumerated().map { index, data in
            if let data {
                var entity = try decoder.decode(Entity.self, from: data)
                entity.key = keys[index]
                return entity
            }
            return nil
        }
    }

    public func getEntity<Entity: _Entity>(
        _ type: Entity.Type,
        key: Entity.Key,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Entity? {
        (try await getEntities(keys: [key], file: file, function: function, line: line))[0]
    }

    enum RegetError: Error {
        case entityIDIncomplete
        case entityNotFound
    }

    public func reget<Entity: _Entity>(
        entity: inout Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        switch entity.key.id {
        case .incomplete:
            throw RegetError.entityIDIncomplete
        case .named, .uniq:
            break
        }

        guard let updated: Entity = (try await getEntities(keys: [entity.key], file: file, function: function, line: line))[0] else {
            throw RegetError.entityNotFound
        }

        entity = updated
    }

    public func containsEntities<Key: AnyKey>(
        keys: [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Bool] {
        storageKeys(fromEntityKeys: keys)
            .map { storage.keys.contains($0) }
    }

    public func containsEntity<Key: AnyKey>(
        key: Key,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Bool {
        (try await containsEntities(keys: [key], file: file, function: function, line: line))[0]
    }
}
