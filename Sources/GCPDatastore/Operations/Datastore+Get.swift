import GCPTrace

extension Datastore {

    // MARK: - Get

    /// Lookups the entities for the given keys.
    /// - Parameter keys: Keys representing the entities to lookup.
    /// - Returns: Array of decoded entities. Any entity may be `nil` if it didn't exist.
    public static func getEntities<Entity>(keys: [Entity.Key], trace: Trace?, projectID: String = defaultProjectID) async throws -> [Entity?]
    where
        Entity: GCPDatastore.Entity,
        Entity.Key: GCPDatastore.AnyKey
    {
        try await client.ensureAuthentication(authorization: &authorization)

        let response = try await trace.recordSpan(named: "datastore-lookup") { span in
            try await client.lookup(.with {
                $0.projectID = projectID
                $0.keys = keys.map({ $0.raw })
            })
        }

        let decoder = EntityDecoder()

        return try keys.map { key in
            if let raw = response.found.first(where: { $0.entity.key.path.last!.idType == key.id.raw }) {
                return try decoder.decode(Entity.self, from: raw.entity)
            } else {
                return nil
            }
        }
    }

    /// Lookups the entitiy for a given key.
    /// - Parameter key: Key representing the entity to lookup.
    /// - Returns: Decoded entity. May be `nil` if it didn't exist.
    public static func getEntity<Entity>(key: Entity.Key, trace: Trace?, projectID: String = defaultProjectID) async throws -> Entity?
    where
        Entity: GCPDatastore.Entity,
        Entity.Key: GCPDatastore.AnyKey
    {
        (try await getEntities(keys: [key], trace: trace, projectID: projectID))[0]
    }

    enum RegetError: Error {
        case entityIDIncomplete
        case entityNotFound
    }

    public static func reget<Entity>(entity: inout Entity, trace: Trace?, projectID: String = defaultProjectID) async throws
    where
        Entity: GCPDatastore.Entity,
        Entity.Key: GCPDatastore.AnyKey
    {
#if DEBUG
        switch entity.key.id {
        case .incomplete:
            throw RegetError.entityIDIncomplete
        case .named, .uniq:
            break
        }
#endif

        guard let updated: Entity = (try await getEntities(keys: [entity.key], trace: trace, projectID: projectID))[0] else {
            throw RegetError.entityNotFound
        }

        entity = updated
    }

    // MARK: - Exists

    /// Checks if provided keys eixsts in the datastore.
    /// - Returns: Array of booleans. `true` if key exists, else, `false`. Ordered same way was provided keys array.
    public static func containsEntities<Key>(keys: [Key], trace: Trace?, projectID: String = defaultProjectID) async throws -> [Bool]
    where
        Key: AnyKey
    {
        try await client.ensureAuthentication(authorization: &authorization)
        
        let response = try await client.lookup(.with {
            $0.projectID = projectID
            $0.keys = keys.map({ $0.raw })
        })
        return keys.map { key in
            response.found.contains(where: { $0.entity.key.path.last!.idType == key.id.raw })
        }
    }

    /// Checks if provided key exists in the datastore.
    /// - Returns: `true` if key exists, else, `false`.
    public static func containsEntity<Key>(key: Key, trace: Trace?, projectID: String = defaultProjectID) async throws -> Bool
    where
        Key: AnyKey
    {
        (try await containsEntities(keys: [key], trace: trace, projectID: projectID))[0]
    }
}
