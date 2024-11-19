import CloudCore
import RetryableTask
import Tracing

extension Datastore {

    // MARK: - By Key

    public func deleteEntities<Key>(
        keys: [Key],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Key: AnyKey
    {
        let projectID = try self.projectID
        try await withSpan("datastore-delete", ofKind: .client) { span in
            span.attributes["datastore/kind"] = Key.kind
            try await withRetryableTask(logger: logger, operation: { [client] in
                _ = try await client.commit(.with {
                    $0.projectID = projectID
                    $0.mutations = keys.map { key in
                            .with {
                                $0.operation = .delete(key.raw)
                            }
                    }
                    $0.mode = .nonTransactional
                })
            }, file: file, function: function, line: line)
        }
    }

    public func deleteEntity<Key>(
        key: Key,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Key: AnyKey
    {
        try await deleteEntities(keys: [key], file: file, function: function, line: line)
    }

    // MARK: - By Entity

    public func delete<Entity>(
        entities: [Entity],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        try await deleteEntities(keys: entities.map({ $0.key}), file: file, function: function, line: line)
    }

    public func delete<Entity>(
        _ entity: Entity,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        try await deleteEntity(key: entity.key, file: file, function: function, line: line)
    }

    // MARK: - By Query

    public func deleteEntities<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        let keys = try await getKeys(query: query, file: file, function: function, line: line)
        if !keys.isEmpty {
            try await deleteEntities(keys: keys, file: file, function: function, line: line)
        }
    }
}
