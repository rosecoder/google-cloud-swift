import CloudCore
import CloudTrace
import RetryableTask

extension Datastore {

    /// Creates or updates given entities.  Also updates the key for entities where the key is incomplete.
    /// - Parameter entities: Entities to create or update.
    public static func put<Entity>(
        entities: inout [Entity],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        let projectID = await Environment.current.projectID
        let encoder = EntityEncoder()
        let rawEntities: [Google_Datastore_V1_Entity] = try entities
            .map { try encoder.encode($0) }

        let result: Google_Datastore_V1_CommitResponse = try await context.trace.recordSpan(named: "datastore-put", kind: .client, attributes: [
            "datastore/kind": Entity.Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger, operation: {
                try await shared.client(context: context).commit(.with {
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
    public static func put<Entity>(
        entity: inout Entity,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        var entities = [entity]
        try await put(entities: &entities, context: context, file: file, function: function, line: line)
        entity = entities[0]
    }

    // MARK: - Allocate ID

    /// Allocates IDs of a set of keys with incomplete ids.
    /// - Parameters:
    ///   - keys: Keys with incomplete ids to allocate.
    public static func allocateIDs<Key>(
        _ keys: inout [Key],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Key: AnyKey
    {
        precondition(!keys.contains(where: { $0.id != .incomplete }))

        let projectID = await Environment.current.projectID
        let result: Google_Datastore_V1_AllocateIdsResponse = try await context.trace.recordSpan(named: "datastore-allocate-ids", kind: .client, attributes: [
            "datastore/kind": Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger, operation: { [keys] in
                try await shared.client(context: context).allocateIds(.with {
                    $0.projectID = projectID
                    $0.keys = keys.map { $0.raw }
                })
            }, file: file, function: function, line: line)
        }
        for (index, key) in result.keys.enumerated() {
            keys[index] = .init(raw: key)
        }
    }

    public static func allocateID<Key>(
        _ key: inout Key,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Key: AnyKey
    {
        var keys = [key]
        try await allocateIDs(&keys, context: context, file: file, function: function, line: line)
        key = keys[0]
    }

    public static func allocateKey<Key>(
        _ keyType: Key.Type,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Key
    where Key: IndependentKey
    {
        var keys = [Key.init(id: .incomplete)]
        try await allocateIDs(&keys, context: context, file: file, function: function, line: line)
        return keys[0]
    }

    public static func allocateKey<Key>(
        _ keyType: Key.Type,
        namespace: Namespace,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Key
    where Key: IndependentNamespaceableKey
    {
        var keys = [Key.init(id: .incomplete, namespace: namespace)]
        try await allocateIDs(&keys, context: context, file: file, function: function, line: line)
        return keys[0]
    }
}
