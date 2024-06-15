import CloudCore
import CloudTrace
import RetryableTask

extension Datastore {

    // MARK: - By Key

    public static func deleteEntities<Key>(
        keys: [Key], context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Key: AnyKey
    {
        let projectID = await Environment.current.projectID
        try await context.trace.recordSpan(named: "datastore-delete", kind: .client, attributes: [
            "datastore/kind": Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger, operation: {
                _ = try await shared.client(context: context).commit(.with {
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

    public static func deleteEntity<Key>(
        key: Key,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Key: AnyKey
    {
        try await deleteEntities(keys: [key], context: context, file: file, function: function, line: line)
    }

    // MARK: - By Entity

    public static func delete<Entity>(
        entities: [Entity],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        try await deleteEntities(keys: entities.map({ $0.key}), context: context, file: file, function: function, line: line)
    }

    public static func delete<Entity>(
        _ entity: Entity, 
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        try await deleteEntity(key: entity.key, context: context, file: file, function: function, line: line)
    }

    // MARK: - By Query

    public static func deleteEntities<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        let keys = try await getKeys(query: query, context: context, file: file, function: function, line: line)
        if !keys.isEmpty {
            try await deleteEntities(keys: keys, context: context, file: file, function: function, line: line)
        }
    }
}
