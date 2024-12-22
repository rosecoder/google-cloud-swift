import CloudCore
import RetryableTask
import Tracing

extension Datastore {

    /// Lookups the entities for the given keys.
    /// - Parameter keys: Keys representing the entities to lookup.
    /// - Returns: Array of decoded entities. Any entity may be `nil` if it didn't exist.
    public func getEntities<Entity: _Entity>(
        keys: [Entity.Key],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Entity?] {
        let rawKeys = keys.map { $0.raw }

        let response: Google_Datastore_V1_LookupResponse = try await withSpan("datastore-lookup", ofKind: .client) { span in
            span.attributes["datastore/kind"] = Entity.Key.kind
            return try await withRetryableTask(logger: logger, operation: { [client] in
                try await client.lookup(.with {
                    $0.projectID = projectID
                    $0.keys = rawKeys
                })
            }, file: file, function: function, line: line)
        }

        let decoder = EntityDecoder()

        return try rawKeys.map { rawKey in
            if let raw = response.found.first(where: {
                guard rawKey.path.count == $0.entity.key.path.count else {
                    return false
                }
                for (lhsPath, rhsPath) in zip(rawKey.path, $0.entity.key.path) {
                    if lhsPath.kind != rhsPath.kind || lhsPath.idType != rhsPath.idType {
                        return false
                    }
                }
                return true
            }) {
                return try decoder.decode(Entity.self, from: raw.entity)
            } else {
                return nil
            }
        }
    }

    /// Lookups the entitiy for a given key.
    /// - Parameter key: Key representing the entity to lookup.
    /// - Returns: Decoded entity. May be `nil` if it didn't exist.
    public func getEntity<Entity: _Entity>(
        _ type: Entity.Type = Entity.self,
        key: Entity.Key,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Entity? {
        (try await getEntities(keys: [key], file: file, function: function, line: line))[0]
    }

    enum RegetError: Error {
        case entityIDIncomplete
        case entityNotFound
    }

    public func reget<Entity: _Entity>(
        entity: inout Entity,
        file: String,
        function: String,
        line: UInt
    ) async throws {
#if DEBUG
        switch entity.key.id {
        case .incomplete:
            throw RegetError.entityIDIncomplete
        case .named, .uniq:
            break
        }
#endif

        guard let updated: Entity = (try await getEntities(keys: [entity.key], file: file, function: function, line: line))[0] else {
            throw RegetError.entityNotFound
        }

        entity = updated
    }

    // MARK: - Exists

    /// Checks if provided keys exists in the datastore.
    /// - Returns: Array of booleans. `true` if key exists, else, `false`. Ordered same way was provided keys array.
    public func containsEntities<Key: AnyKey>(
        keys: [Key],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [Bool] {
        let response: Google_Datastore_V1_LookupResponse = try await withSpan("datastore-lookup", ofKind: .client) { span in
            span.attributes["datastore/kind"] = Key.kind
            return try await withRetryableTask(logger: logger, operation: { [client] in
                try await client.lookup(.with {
                    $0.projectID = projectID
                    $0.keys = keys.map({ $0.raw })
                })
            }, file: file, function: function, line: line)
        }
        return keys.map { key in
            response.found.contains(where: { $0.entity.key.path.last!.idType == key.id.raw })
        }
    }

    /// Checks if provided key exists in the datastore.
    /// - Returns: `true` if key exists, else, `false`.
    public func containsEntity<Key: AnyKey>(
        key: Key,
        file: String,
        function: String,
        line: UInt
    ) async throws -> Bool {
        (try await containsEntities(keys: [key], file: file, function: function, line: line))[0]
    }
}
