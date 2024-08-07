import CloudCore
import CloudTrace
import RetryableTask

extension Datastore {

    private static func performQuery<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        projection: [Google_Datastore_V1_Projection],
        cursor: inout Cursor?,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Google_Datastore_V1_EntityResult]
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        let projectID = await Environment.current.projectID
        let response: Google_Datastore_V1_RunQueryResponse = try await context.trace.recordSpan(named: "datastore-query", kind: .client, attributes: [
            "datastore/kind": Entity.Key.kind,
        ]) { span in
            try await withRetryableTask(logger: context.logger, operation: { [cursor] in
                try await shared.client(context: context).runQuery(.with {
                    $0.projectID = projectID
                    $0.partitionID = .with {
                        $0.namespaceID = query.namespace.rawValue
                    }
                    $0.queryType = .query(.with {
                        $0.projection = projection
                        $0.kind = [.with {
                            $0.name = query.kind
                        }]
                        if !query.filters.isEmpty {
                            $0.filter = .with {
                                $0.filterType = .compositeFilter(.with {
                                    $0.op = .and
                                    $0.filters = query.filters.map { filter in
                                        Google_Datastore_V1_Filter.with {
                                            $0.propertyFilter = filter
                                        }
                                    }
                                })
                            }
                        }
                        $0.order = query.orders
                        $0.distinctOn = [] // TODO: Implement distinct on
                        if let cursor {
                            $0.startCursor = cursor.rawValue
                        }
                        //                  $0.endCursor =
                        //                  $0.offset =
                        if let limit = query.limit {
                            $0.limit = .with {
                                $0.value = limit
                            }
                        }
                    })
                })
            }, file: file, function: function, line: line)
        }
        switch response.batch.moreResults {
        case .moreResultsAfterCursor, .moreResultsAfterLimit, .notFinished:
            if !response.batch.endCursor.isEmpty {
                // Can we determine if there's really are more results?
                if let limit = query.limit {
                    cursor = response.batch.entityResults.count >= limit
                        ? Cursor(rawValue: response.batch.endCursor)
                        : nil
                } else {
                    // No
                    cursor = Cursor(rawValue: response.batch.endCursor)
                }
            } else {
                context.logger.error("Datastore query was paginated, but cursor is missing. This may break pagination.")
                cursor = nil
            }
        case .noMoreResults:
            cursor = nil
        case .unspecified:
            if cursor != nil || query.limit != nil {
                context.logger.error("Datastore query was paginated, but datastore retruned no indication of more data (unspecified batch more results). This may break pagination.")
            }
            cursor = nil
        case .UNRECOGNIZED(let rawValue):
            context.logger.error("Unrecognized datastore query batch more results. This may break pagination.", metadata: [
                "rawValue": .stringConvertible(rawValue),
            ])
            cursor = nil
        }
        return response.batch.entityResults
    }

    public static func getEntities<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        cursor: inout Cursor?,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity]
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        let raws = try await performQuery(query: query, projection: [], cursor: &cursor, context: context, file: file, function: function, line: line)

        let decoder = EntityDecoder()
        return try raws.map {
            try decoder.decode(Entity.self, from: $0.entity)
        }
    }

    public static func getEntities<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity]
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        var cursor: Cursor?
        return try await getEntities(query: query, cursor: &cursor, context: context, file: file, function: function, line: line)
    }

    public static func getKeys<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        cursor: inout Cursor?,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity.Key]
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        let raws = try await performQuery(
            query: query,
            projection: [.with {
                $0.property = .with {
                    $0.name = "__key__"
                }
            }],
            cursor: &cursor,
            context: context,
            file: file,
            function: function,
            line: line
        )
        return raws.map { Entity.Key.init(raw: $0.entity.key) }
    }

    public static func getKeys<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        context: Context,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [Entity.Key]
    where
        Entity: _Entity,
        Entity.Key: AnyKey
    {
        var cursor: Cursor?
        return try await getKeys(query: query, cursor: &cursor, context: context, file: file, function: function, line: line)
    }
}
