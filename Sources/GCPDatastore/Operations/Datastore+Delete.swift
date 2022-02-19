extension Datastore {

    // MARK: - By Key

    public static func deleteEntities<Key>(keys: [Key], projectID: String = defaultProjectID) async throws
    where Key: GCPDatastore.AnyKey
    {
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

    public static func deleteEntity<Key>(key: Key, projectID: String = defaultProjectID) async throws
    where Key: GCPDatastore.AnyKey
    {
        try await deleteEntities(keys: [key], projectID: projectID)
    }

    // MARK: - By Entity

    public static func delete<Entity>(entities: [Entity], projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        try await deleteEntities(keys: entities.map({ $0.key}), projectID: projectID)
    }

    public static func delete<Entity>(_ entity: Entity, projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        try await deleteEntity(key: entity.key, projectID: projectID)
    }

    // MARK: - By Query

    public static func deleteEntities<Entity, CodingKeys>(query: Query<Entity, CodingKeys>, projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        let keys = try await getKeys(query: query, projectID: projectID)
        try await deleteEntities(keys: keys, projectID: projectID)
    }
}
