import CloudCore
import CloudTrace
import RetryableTask

extension Datastore {

    // MARK: - Get

    /// Lookups the entities for the given keys.
    /// - Parameter keys: Keys representing the entities to lookup.
    /// - Returns: Array of decoded entities. Any entity may be `nil` if it didn't exist.
    public static func getEntities<Entity>(
        keys: [Entity.Key],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity?]
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        let projectID = await Environment.current.projectID
        let rawKeys = keys.map { $0.raw }

        let response: Google_Datastore_V1_LookupResponse = try await context.trace.recordSpan(named: "datastore-lookup", kind: .client, attributes: [
            "datastore/kind": Entity.Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger, operation: {
                try await shared.client(context: context).lookup(.with {
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
    public static func getEntity<Entity>(
        _ type: Entity.Type = Entity.self,
        key: Entity.Key,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Entity?
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        (try await getEntities(keys: [key], context: context, file: file, function: function, line: line))[0]
    }

    enum RegetError: Error {
        case entityIDIncomplete
        case entityNotFound
    }

    public static func reget<Entity>(
        entity: inout Entity,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
#if DEBUG
        switch entity.key.id {
        case .incomplete:
            throw RegetError.entityIDIncomplete
        case .named, .uniq:
            break
        }
#endif

        guard let updated: Entity = (try await getEntities(keys: [entity.key], context: context, file: file, function: function, line: line))[0] else {
            throw RegetError.entityNotFound
        }

        entity = updated
    }

    // MARK: - Exists

    /// Checks if provided keys eixsts in the datastore.
    /// - Returns: Array of booleans. `true` if key exists, else, `false`. Ordered same way was provided keys array.
    public static func containsEntities<Key>(
        keys: [Key],
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Bool]
    where
        Key: AnyKey
    {
        let projectID = await Environment.current.projectID
        let response: Google_Datastore_V1_LookupResponse = try await context.trace.recordSpan(named: "datastore-lookup", kind: .client, attributes: [
            "datastore/kind": Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger, operation: {
                try await shared.client(context: context).lookup(.with {
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
    public static func containsEntity<Key>(
        key: Key,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> Bool
    where
        Key: AnyKey
    {
        (try await containsEntities(keys: [key], context: context, file: file, function: function, line: line))[0]
    }
}
