import CloudTrace
import RetryableTask

extension Datastore {

    // MARK: - By Key

    public static func deleteEntities<Key>(keys: [Key], context: Context, projectID: String = defaultProjectID) async throws
    where Key: AnyKey
    {
        try await context.trace.recordSpan(named: "datastore-delete", kind: .client, attributes: [
            "datastore/kind": Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger) {
                _ = try await shared.client(context: context).commit(.with {
                    $0.projectID = projectID
                    $0.mutations = keys.map { key in
                            .with {
                                $0.operation = .delete(key.raw)
                            }
                    }
                    $0.mode = .nonTransactional
                })
            }
        }
    }

    public static func deleteEntity<Key>(key: Key, context: Context, projectID: String = defaultProjectID) async throws
    where Key: AnyKey
    {
        try await deleteEntities(keys: [key], context: context, projectID: projectID)
    }

    // MARK: - By Entity

    public static func delete<Entity>(entities: [Entity], context: Context, projectID: String = defaultProjectID) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        try await deleteEntities(keys: entities.map({ $0.key}), context: context, projectID: projectID)
    }

    public static func delete<Entity>(_ entity: Entity, context: Context, projectID: String = defaultProjectID) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        try await deleteEntity(key: entity.key, context: context, projectID: projectID)
    }

    // MARK: - By Query

    public static func deleteEntities<Entity, CodingKeys>(query: Query<Entity, CodingKeys>, context: Context, projectID: String = defaultProjectID) async throws
    where Entity: _Entity,
          Entity.Key: AnyKey
    {
        let keys = try await getKeys(query: query, context: context, projectID: projectID)
        if !keys.isEmpty {
            try await deleteEntities(keys: keys, context: context, projectID: projectID)
        }
    }
}
