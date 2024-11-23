import CloudCore
import RetryableTask
import Tracing

extension Datastore {

    /// Creates or updates given entities.  Also updates the key for entities where the key is incomplete.
    /// - Parameter entities: Entities to create or update.
    public func put<Entity: _Entity>(
        entities: inout [Entity],
        file: String,
        function: String,
        line: UInt
    ) async throws {
        let projectID = try self.projectID
        let encoder = EntityEncoder()
        let rawEntities: [Google_Datastore_V1_Entity] = try entities
            .map { try encoder.encode($0) }

        let result: Google_Datastore_V1_CommitResponse = try await withSpan("datastore-put", ofKind: .client) { span in
            span.attributes["datastore/kind"] = Entity.Key.kind
            return try await withRetryableTask(logger: logger, operation: { [client] in
                try await client.commit(.with {
                    $0.projectID = projectID
                    $0.mutations = rawEntities.map { raw in
                            .with {
                                $0.operation = .upsert(raw)
                            }
                    }
                    $0.mode = .nonTransactional
                })
            }, file: file, function: function, line: line)
        }

        // Update keys for all entities
        for (index, result) in result.mutationResults.enumerated() {
            if result.hasKey {
                entities[index].key = Entity.Key.init(raw: result.key)
            }
            // TODO: Detect conflict with `result.conflictDetected`?
        }
    }

    /// Creates or updates given entity.  Also updates the key if the entity's  key is incomplete.
    /// - Parameter entity: Entity to create or update.
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

    // MARK: - Allocate ID

    /// Allocates IDs of a set of keys with incomplete ids.
    /// - Parameters:
    ///   - keys: Keys with incomplete ids to allocate.
    public func allocateIDs<Key: AnyKey>(
        _ keys: inout [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws {
        precondition(!keys.contains(where: { $0.id != .incomplete }))

        let projectID = try self.projectID
        let result: Google_Datastore_V1_AllocateIdsResponse = try await withSpan("datastore-allocate-ids", ofKind: .client) { span in
            span.attributes["datastore/kind"] = Key.kind
            return try await withRetryableTask(logger: logger, operation: { [keys, client] in
                try await client.allocateIds(.with {
                    $0.projectID = projectID
                    $0.keys = keys.map { $0.raw }
                })
            }, file: file, function: function, line: line)
        }
        for (index, key) in result.keys.enumerated() {
            keys[index] = .init(raw: key)
        }
    }

    public func allocateID<Key: AnyKey>(
        _ key: inout Key,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        var keys = [key]
        try await allocateIDs(&keys, file: file, function: function, line: line)
        key = keys[0]
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
