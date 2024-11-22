// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the gRPC Swift generator plugin for the protocol buffer compiler.
// Source: google/datastore/v1/datastore.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/grpc/grpc-swift

import GRPCCore
import GRPCProtobuf

package enum Google_Datastore_V1_Datastore {
    package static let descriptor = GRPCCore.ServiceDescriptor.google_datastore_v1_Datastore
    package enum Method {
        package enum Lookup {
            package typealias Input = Google_Datastore_V1_LookupRequest
            package typealias Output = Google_Datastore_V1_LookupResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "Lookup"
            )
        }
        package enum RunQuery {
            package typealias Input = Google_Datastore_V1_RunQueryRequest
            package typealias Output = Google_Datastore_V1_RunQueryResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "RunQuery"
            )
        }
        package enum RunAggregationQuery {
            package typealias Input = Google_Datastore_V1_RunAggregationQueryRequest
            package typealias Output = Google_Datastore_V1_RunAggregationQueryResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "RunAggregationQuery"
            )
        }
        package enum BeginTransaction {
            package typealias Input = Google_Datastore_V1_BeginTransactionRequest
            package typealias Output = Google_Datastore_V1_BeginTransactionResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "BeginTransaction"
            )
        }
        package enum Commit {
            package typealias Input = Google_Datastore_V1_CommitRequest
            package typealias Output = Google_Datastore_V1_CommitResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "Commit"
            )
        }
        package enum Rollback {
            package typealias Input = Google_Datastore_V1_RollbackRequest
            package typealias Output = Google_Datastore_V1_RollbackResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "Rollback"
            )
        }
        package enum AllocateIds {
            package typealias Input = Google_Datastore_V1_AllocateIdsRequest
            package typealias Output = Google_Datastore_V1_AllocateIdsResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "AllocateIds"
            )
        }
        package enum ReserveIds {
            package typealias Input = Google_Datastore_V1_ReserveIdsRequest
            package typealias Output = Google_Datastore_V1_ReserveIdsResponse
            package static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Datastore_V1_Datastore.descriptor.fullyQualifiedService,
                method: "ReserveIds"
            )
        }
        package static let descriptors: [GRPCCore.MethodDescriptor] = [
            Lookup.descriptor,
            RunQuery.descriptor,
            RunAggregationQuery.descriptor,
            BeginTransaction.descriptor,
            Commit.descriptor,
            Rollback.descriptor,
            AllocateIds.descriptor,
            ReserveIds.descriptor
        ]
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    package typealias ClientProtocol = Google_Datastore_V1_Datastore_ClientProtocol
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    package typealias Client = Google_Datastore_V1_Datastore_Client
}

extension GRPCCore.ServiceDescriptor {
    package static let google_datastore_v1_Datastore = Self(
        package: "google.datastore.v1",
        service: "Datastore"
    )
}

/// Each RPC normalizes the partition IDs of the keys in its input entities,
/// and always returns entities with keys with normalized partition IDs.
/// This applies to all keys and entities, including those in values, except keys
/// with both an empty path and an empty or unset partition ID. Normalization of
/// input keys sets the project ID (if not already set) to the project ID from
/// the request.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
package protocol Google_Datastore_V1_Datastore_ClientProtocol: Sendable {
    /// Looks up entities by key.
    func lookup<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_LookupRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_LookupRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_LookupResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_LookupResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Queries for entities.
    func runQuery<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RunQueryRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_RunQueryRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_RunQueryResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunQueryResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Runs an aggregation query.
    func runAggregationQuery<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RunAggregationQueryRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_RunAggregationQueryRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_RunAggregationQueryResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunAggregationQueryResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Begins a new transaction.
    func beginTransaction<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_BeginTransactionRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_BeginTransactionRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_BeginTransactionResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_BeginTransactionResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Commits a transaction, optionally creating, deleting or modifying some
    /// entities.
    func commit<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_CommitRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_CommitRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_CommitResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_CommitResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Rolls back a transaction.
    func rollback<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RollbackRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_RollbackRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_RollbackResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RollbackResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Allocates IDs for the given keys, which is useful for referencing an entity
    /// before it is inserted.
    func allocateIds<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_AllocateIdsRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_AllocateIdsRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_AllocateIdsResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_AllocateIdsResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Prevents the supplied keys' IDs from being auto-allocated by Cloud
    /// Datastore.
    func reserveIds<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_ReserveIdsRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_ReserveIdsRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_ReserveIdsResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_ReserveIdsResponse>) async throws -> R
    ) async throws -> R where R: Sendable
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Google_Datastore_V1_Datastore.ClientProtocol {
    package func lookup<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_LookupRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_LookupResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.lookup(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_LookupRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_LookupResponse>(),
            options: options,
            body
        )
    }
    
    package func runQuery<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RunQueryRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunQueryResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.runQuery(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_RunQueryRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_RunQueryResponse>(),
            options: options,
            body
        )
    }
    
    package func runAggregationQuery<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RunAggregationQueryRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunAggregationQueryResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.runAggregationQuery(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_RunAggregationQueryRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_RunAggregationQueryResponse>(),
            options: options,
            body
        )
    }
    
    package func beginTransaction<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_BeginTransactionRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_BeginTransactionResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.beginTransaction(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_BeginTransactionRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_BeginTransactionResponse>(),
            options: options,
            body
        )
    }
    
    package func commit<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_CommitRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_CommitResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.commit(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_CommitRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_CommitResponse>(),
            options: options,
            body
        )
    }
    
    package func rollback<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RollbackRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RollbackResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.rollback(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_RollbackRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_RollbackResponse>(),
            options: options,
            body
        )
    }
    
    package func allocateIds<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_AllocateIdsRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_AllocateIdsResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.allocateIds(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_AllocateIdsRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_AllocateIdsResponse>(),
            options: options,
            body
        )
    }
    
    package func reserveIds<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_ReserveIdsRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_ReserveIdsResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.reserveIds(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Datastore_V1_ReserveIdsRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Datastore_V1_ReserveIdsResponse>(),
            options: options,
            body
        )
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Google_Datastore_V1_Datastore.ClientProtocol {
    /// Looks up entities by key.
    package func lookup<Result>(
        _ message: Google_Datastore_V1_LookupRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_LookupResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_LookupRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.lookup(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Queries for entities.
    package func runQuery<Result>(
        _ message: Google_Datastore_V1_RunQueryRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunQueryResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_RunQueryRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.runQuery(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Runs an aggregation query.
    package func runAggregationQuery<Result>(
        _ message: Google_Datastore_V1_RunAggregationQueryRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunAggregationQueryResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_RunAggregationQueryRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.runAggregationQuery(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Begins a new transaction.
    package func beginTransaction<Result>(
        _ message: Google_Datastore_V1_BeginTransactionRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_BeginTransactionResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_BeginTransactionRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.beginTransaction(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Commits a transaction, optionally creating, deleting or modifying some
    /// entities.
    package func commit<Result>(
        _ message: Google_Datastore_V1_CommitRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_CommitResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_CommitRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.commit(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Rolls back a transaction.
    package func rollback<Result>(
        _ message: Google_Datastore_V1_RollbackRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RollbackResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_RollbackRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.rollback(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Allocates IDs for the given keys, which is useful for referencing an entity
    /// before it is inserted.
    package func allocateIds<Result>(
        _ message: Google_Datastore_V1_AllocateIdsRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_AllocateIdsResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_AllocateIdsRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.allocateIds(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Prevents the supplied keys' IDs from being auto-allocated by Cloud
    /// Datastore.
    package func reserveIds<Result>(
        _ message: Google_Datastore_V1_ReserveIdsRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_ReserveIdsResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Datastore_V1_ReserveIdsRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.reserveIds(
            request: request,
            options: options,
            handleResponse
        )
    }
}

/// Each RPC normalizes the partition IDs of the keys in its input entities,
/// and always returns entities with keys with normalized partition IDs.
/// This applies to all keys and entities, including those in values, except keys
/// with both an empty path and an empty or unset partition ID. Normalization of
/// input keys sets the project ID (if not already set) to the project ID from
/// the request.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
package struct Google_Datastore_V1_Datastore_Client: Google_Datastore_V1_Datastore.ClientProtocol {
    private let client: GRPCCore.GRPCClient
    
    package init(wrapping client: GRPCCore.GRPCClient) {
        self.client = client
    }
    
    /// Looks up entities by key.
    package func lookup<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_LookupRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_LookupRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_LookupResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_LookupResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.Lookup.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Queries for entities.
    package func runQuery<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RunQueryRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_RunQueryRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_RunQueryResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunQueryResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.RunQuery.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Runs an aggregation query.
    package func runAggregationQuery<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RunAggregationQueryRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_RunAggregationQueryRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_RunAggregationQueryResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RunAggregationQueryResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.RunAggregationQuery.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Begins a new transaction.
    package func beginTransaction<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_BeginTransactionRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_BeginTransactionRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_BeginTransactionResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_BeginTransactionResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.BeginTransaction.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Commits a transaction, optionally creating, deleting or modifying some
    /// entities.
    package func commit<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_CommitRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_CommitRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_CommitResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_CommitResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.Commit.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Rolls back a transaction.
    package func rollback<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_RollbackRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_RollbackRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_RollbackResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_RollbackResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.Rollback.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Allocates IDs for the given keys, which is useful for referencing an entity
    /// before it is inserted.
    package func allocateIds<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_AllocateIdsRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_AllocateIdsRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_AllocateIdsResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_AllocateIdsResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.AllocateIds.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Prevents the supplied keys' IDs from being auto-allocated by Cloud
    /// Datastore.
    package func reserveIds<R>(
        request: GRPCCore.ClientRequest<Google_Datastore_V1_ReserveIdsRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Datastore_V1_ReserveIdsRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Datastore_V1_ReserveIdsResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Datastore_V1_ReserveIdsResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Datastore_V1_Datastore.Method.ReserveIds.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
}