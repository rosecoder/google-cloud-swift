import GCPTrace

extension Datastore {

    private static func performQuery<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        projection: [Google_Datastore_V1_Projection],
        trace: Trace?,
        projectID: String
    ) async throws -> [Google_Datastore_V1_EntityResult]
    where
        Entity: GCPDatastore.Entity,
        Entity.Key: GCPDatastore.AnyKey
    {
        let response: Google_Datastore_V1_RunQueryResponse = try await trace.recordSpan(named: "datastore-query") { span in
            try await client.ensureAuthentication(authorization: &authorization, spanParent: span)

            return try await client.runQuery(.with {
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
//                  $0.startCursor = // TODO: Implement cursor support
//                  $0.endCursor =
//                  $0.offset =
                    if let limit = query.limit {
                        $0.limit = .with {
                            $0.value = limit
                        }
                    }
                })
            })
        }
        return response.batch.entityResults
    }

    public static func getEntities<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        trace: Trace?,
        projectID: String = defaultProjectID
    ) async throws -> [Entity]
    where
        Entity: GCPDatastore.Entity,
        Entity.Key: GCPDatastore.AnyKey
    {
        let raws = try await performQuery(query: query, projection: [], trace: trace, projectID: projectID)

        let decoder = EntityDecoder()
        return try raws.map {
            try decoder.decode(Entity.self, from: $0.entity)
        }
    }

    public static func getKeys<Entity, CodingKeys>(
        query: Query<Entity, CodingKeys>,
        trace: Trace?,
        projectID: String = defaultProjectID
    ) async throws -> [Entity.Key]
    where
        Entity: GCPDatastore.Entity,
        Entity.Key: GCPDatastore.AnyKey
    {
        let raws = try await performQuery(
            query: query,
            projection: [.with {
                $0.property = .with {
                    $0.name = "__key__"
                }
            }],
            trace: trace,
            projectID: projectID
        )
        return raws.map { Entity.Key.init(raw: $0.entity.key) }
    }
}
