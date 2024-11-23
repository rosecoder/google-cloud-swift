public protocol DatastoreProtocol: Sendable {

    func deleteEntities<Key: AnyKey>(
        keys: [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws

    func deleteEntity<Key: AnyKey>(
        key: Key,
        file: String,
        function: String,
        line: UInt
    ) async throws

    func delete<Entity: _Entity>(
        entities: [Entity],
        file: String,
        function: String,
        line: UInt
    ) async throws

    func delete<Entity: _Entity>(
        _ entity: Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws

    func deleteEntities<Entity: _Entity>(
        query: Query<Entity>,
        file: String,
        function: String,
        line: UInt
    ) async throws

    func getEntities<Entity: _Entity>(
        keys: [Entity.Key],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity?]

    func getEntity<Entity: _Entity>(
        _ type: Entity.Type,
        key: Entity.Key,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Entity?

    func reget<Entity: _Entity>(
        entity: inout Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws

    func containsEntities<Key: AnyKey>(
        keys: [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Bool]

    func containsEntity<Key: AnyKey>(
        key: Key,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Bool

    func put<Entity: _Entity>(
        entities: inout [Entity],
        file: String,
        function: String,
        line: UInt
    ) async throws

    func put<Entity: _Entity>(
        entity: inout Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws

    func allocateIDs<Key: AnyKey>(
        _ keys: inout [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws

    func allocateID<Key: AnyKey>(
        _ key: inout Key,
        file: String,
        function: String,
        line: UInt
    ) async throws

    func allocateKey<Key: IndependentKey>(
        _ keyType: Key.Type,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Key

    func allocateKey<Key: IndependentNamespaceableKey>(
        _ keyType: Key.Type,
        namespace: Namespace,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Key

    func getEntities<Entity: _Entity>(
        query: Query<Entity>,
        cursor: inout Cursor?,
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity]

    func getEntities<Entity: _Entity>(
        query: Query<Entity>,
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity]

    func getKeys<Entity: _Entity>(
        query: Query<Entity>,
        cursor: inout Cursor?,
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity.Key]

    func getKeys<Entity: _Entity>(
        query: Query<Entity>,
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity.Key]
}

extension DatastoreProtocol {

    public func deleteEntities<Key: AnyKey>(
        keys: [Key],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await deleteEntities(keys: keys, file: file, function: function, line: line)
    }

    public func deleteEntity<Key: AnyKey>(
        key: Key,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await deleteEntity(key: key, file: file, function: function, line: line)
    }

    public func delete<Entity: _Entity>(
        entities: [Entity],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await delete(entities: entities, file: file, function: function, line: line)
    }

    public func delete<Entity: _Entity>(
        _ entity: Entity,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await delete(entity, file: file, function: function, line: line)
    }

    public func deleteEntities<Entity: _Entity>(
        query: Query<Entity>,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await deleteEntities(query: query, file: file, function: function, line: line)
    }

    public func getEntities<Entity: _Entity>(
        keys: [Entity.Key],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity?] {
        try await getEntities(keys: keys, file: file, function: function, line: line)
    }

    public func getEntity<Entity: _Entity>(
        _ type: Entity.Type = Entity.self,
        key: Entity.Key,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Entity? {
        try await getEntity(type, key: key, file: file, function: function, line: line)
    }

    public func reget<Entity: _Entity>(
        entity: inout Entity,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await reget(entity: &entity, file: file, function: function, line: line)
    }

    public func containsEntities<Key: AnyKey>(
        keys: [Key],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Bool] {
        try await containsEntities(keys: keys, file: file, function: function, line: line)
    }

    public func containsEntity<Key: AnyKey>(
        key: Key,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Bool {
        try await containsEntity(key: key, file: file, function: function, line: line)
    }

    public func put<Entity: _Entity>(
        entities: inout [Entity],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await put(entities: &entities, file: file, function: function, line: line)
    }

    public func put<Entity: _Entity>(
        entity: inout Entity,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await put(entity: &entity, file: file, function: function, line: line)
    }

    public func allocateIDs<Key: AnyKey>(
        _ keys: inout [Key],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await allocateIDs(&keys, file: file, function: function, line: line)
    }

    public func allocateID<Key: AnyKey>(
        _ key: inout Key,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws {
        try await allocateID(&key, file: file, function: function, line: line)
    }

    public func allocateKey<Key: IndependentKey>(
        _ keyType: Key.Type,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Key {
        try await allocateKey(keyType, file: file, function: function, line: line)
    }

    public func allocateKey<Key: IndependentNamespaceableKey>(
        _ keyType: Key.Type,
        namespace: Namespace,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Key {
        try await allocateKey(keyType, namespace: namespace, file: file, function: function, line: line)
    }

    public func getEntities<Entity: _Entity>(
        query: Query<Entity>,
        cursor: inout Cursor?,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity] {
        try await getEntities(query: query, cursor: &cursor, file: file, function: function, line: line)
    }

    public func getEntities<Entity: _Entity>(
        query: Query<Entity>,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity] {
        try await getEntities(query: query, file: file, function: function, line: line)
    }

    public func getKeys<Entity: _Entity>(
        query: Query<Entity>,
        cursor: inout Cursor?,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity.Key] {
        try await getKeys(query: query, cursor: &cursor, file: file, function: function, line: line)
    }

    public func getKeys<Entity: _Entity>(
        query: Query<Entity>,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity.Key] {
        try await getKeys(query: query, file: file, function: function, line: line)
    }
}
