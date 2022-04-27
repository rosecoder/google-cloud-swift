extension Datastore {

    /// Creates or updates given entities.  Also updates the key for entities where the key is incomplete.
    /// - Parameter entities: Entities to create or update.
    /// - Returns: Future result.
    public static func put<Entity>(entities: inout [Entity], projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        let encoder = EntityEncoder()
        let rawEntities: [Google_Datastore_V1_Entity] = try entities.map { try encoder.encode($0) }

        try await client.ensureAuthentication(authorization: &authorization)

        let result = try await client.commit(.with {
            $0.projectID = projectID
            $0.mutations = rawEntities.map { raw in
                .with {
                    $0.operation = .upsert(raw)
                }
            }
            $0.mode = .nonTransactional
        })

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
    /// - Returns: Future result.
    public static func put<Entity>(entity: inout Entity, projectID: String = defaultProjectID) async throws
    where Entity: GCPDatastore.Entity,
          Entity.Key: GCPDatastore.AnyKey
    {
        var entities = [entity]
        try await put(entities: &entities, projectID: projectID)
        entity = entities[0]
    }
}
