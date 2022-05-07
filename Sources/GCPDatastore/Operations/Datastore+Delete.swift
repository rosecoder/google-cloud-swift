import GCPTrace

extension Datastore {

    // MARK: - By Key

    public static func deleteEntities<Key>(keys: [Key], trace: Trace?, projectID: String = defaultProjectID) async throws
    where Key: GCPDatastore.AnyKey
    {
        try await trace.recordSpan(named: "datastore-delete") { span in
            try await client.ensureAuthentication(authorization: &authorization, spanParent: span)

            _ = try await client.commit(.with {
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

    public static func deleteEntity<Key>(key: Key, trace: Trace?, projectID: String = defaultProjectID) async throws
    where Key: GCPDatastore.AnyKey
    {
        try await deleteEntities(keys: [key], trace: trace, projectID: projectID)
    }

    // MARK: - By Entity

    public static func delete<Entity>(entities: [Entity], trace: Trace?, projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        try await deleteEntities(keys: entities.map({ $0.key}), trace: trace, projectID: projectID)
    }

    public static func delete<Entity>(_ entity: Entity, trace: Trace?, projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        try await deleteEntity(key: entity.key, trace: trace, projectID: projectID)
    }

    // MARK: - By Query

    public static func deleteEntities<Entity, CodingKeys>(query: Query<Entity, CodingKeys>, trace: Trace?, projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        let keys = try await getKeys(query: query, trace: trace, projectID: projectID)
        try await deleteEntities(keys: keys, trace: trace, projectID: projectID)
    }
}
