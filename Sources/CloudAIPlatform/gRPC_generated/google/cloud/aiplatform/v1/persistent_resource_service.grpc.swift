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
// Source: google/cloud/aiplatform/v1/persistent_resource_service.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/grpc/grpc-swift

import GRPCCore
import GRPCProtobuf

public enum Google_Cloud_Aiplatform_V1_PersistentResourceService {
    public static let descriptor = GRPCCore.ServiceDescriptor.google_cloud_aiplatform_v1_PersistentResourceService
    public enum Method {
        public enum CreatePersistentResource {
            public typealias Input = Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest
            public typealias Output = Google_Longrunning_Operation
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_PersistentResourceService.descriptor.fullyQualifiedService,
                method: "CreatePersistentResource"
            )
        }
        public enum GetPersistentResource {
            public typealias Input = Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest
            public typealias Output = Google_Cloud_Aiplatform_V1_PersistentResource
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_PersistentResourceService.descriptor.fullyQualifiedService,
                method: "GetPersistentResource"
            )
        }
        public enum ListPersistentResources {
            public typealias Input = Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest
            public typealias Output = Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_PersistentResourceService.descriptor.fullyQualifiedService,
                method: "ListPersistentResources"
            )
        }
        public enum DeletePersistentResource {
            public typealias Input = Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest
            public typealias Output = Google_Longrunning_Operation
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_PersistentResourceService.descriptor.fullyQualifiedService,
                method: "DeletePersistentResource"
            )
        }
        public enum UpdatePersistentResource {
            public typealias Input = Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest
            public typealias Output = Google_Longrunning_Operation
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_PersistentResourceService.descriptor.fullyQualifiedService,
                method: "UpdatePersistentResource"
            )
        }
        public enum RebootPersistentResource {
            public typealias Input = Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest
            public typealias Output = Google_Longrunning_Operation
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_PersistentResourceService.descriptor.fullyQualifiedService,
                method: "RebootPersistentResource"
            )
        }
        public static let descriptors: [GRPCCore.MethodDescriptor] = [
            CreatePersistentResource.descriptor,
            GetPersistentResource.descriptor,
            ListPersistentResources.descriptor,
            DeletePersistentResource.descriptor,
            UpdatePersistentResource.descriptor,
            RebootPersistentResource.descriptor
        ]
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public typealias ClientProtocol = Google_Cloud_Aiplatform_V1_PersistentResourceService_ClientProtocol
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public typealias Client = Google_Cloud_Aiplatform_V1_PersistentResourceService_Client
}

extension GRPCCore.ServiceDescriptor {
    public static let google_cloud_aiplatform_v1_PersistentResourceService = Self(
        package: "google.cloud.aiplatform.v1",
        service: "PersistentResourceService"
    )
}

/// A service for managing Vertex AI's machine learning PersistentResource.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public protocol Google_Cloud_Aiplatform_V1_PersistentResourceService_ClientProtocol: Sendable {
    /// Creates a PersistentResource.
    func createPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Gets a PersistentResource.
    func getPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_PersistentResource>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_PersistentResource>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Lists PersistentResources in a Location.
    func listPersistentResources<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Deletes a PersistentResource.
    func deletePersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Updates a PersistentResource.
    func updatePersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Reboots a PersistentResource.
    func rebootPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R
    ) async throws -> R where R: Sendable
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Google_Cloud_Aiplatform_V1_PersistentResourceService.ClientProtocol {
    public func createPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.createPersistentResource(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Longrunning_Operation>(),
            options: options,
            body
        )
    }
    
    public func getPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_PersistentResource>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.getPersistentResource(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Cloud_Aiplatform_V1_PersistentResource>(),
            options: options,
            body
        )
    }
    
    public func listPersistentResources<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.listPersistentResources(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>(),
            options: options,
            body
        )
    }
    
    public func deletePersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.deletePersistentResource(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Longrunning_Operation>(),
            options: options,
            body
        )
    }
    
    public func updatePersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.updatePersistentResource(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Longrunning_Operation>(),
            options: options,
            body
        )
    }
    
    public func rebootPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.rebootPersistentResource(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Longrunning_Operation>(),
            options: options,
            body
        )
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Google_Cloud_Aiplatform_V1_PersistentResourceService.ClientProtocol {
    /// Creates a PersistentResource.
    public func createPersistentResource<Result>(
        _ message: Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.createPersistentResource(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Gets a PersistentResource.
    public func getPersistentResource<Result>(
        _ message: Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_PersistentResource>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.getPersistentResource(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Lists PersistentResources in a Location.
    public func listPersistentResources<Result>(
        _ message: Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.listPersistentResources(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Deletes a PersistentResource.
    public func deletePersistentResource<Result>(
        _ message: Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.deletePersistentResource(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Updates a PersistentResource.
    public func updatePersistentResource<Result>(
        _ message: Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.updatePersistentResource(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Reboots a PersistentResource.
    public func rebootPersistentResource<Result>(
        _ message: Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.rebootPersistentResource(
            request: request,
            options: options,
            handleResponse
        )
    }
}

/// A service for managing Vertex AI's machine learning PersistentResource.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct Google_Cloud_Aiplatform_V1_PersistentResourceService_Client: Google_Cloud_Aiplatform_V1_PersistentResourceService.ClientProtocol {
    private let client: GRPCCore.GRPCClient
    
    public init(wrapping client: GRPCCore.GRPCClient) {
        self.client = client
    }
    
    /// Creates a PersistentResource.
    public func createPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_CreatePersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_PersistentResourceService.Method.CreatePersistentResource.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Gets a PersistentResource.
    public func getPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_GetPersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_PersistentResource>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_PersistentResource>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_PersistentResourceService.Method.GetPersistentResource.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Lists PersistentResources in a Location.
    public func listPersistentResources<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_ListPersistentResourcesRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_ListPersistentResourcesResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_PersistentResourceService.Method.ListPersistentResources.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Deletes a PersistentResource.
    public func deletePersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_DeletePersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_PersistentResourceService.Method.DeletePersistentResource.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Updates a PersistentResource.
    public func updatePersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_UpdatePersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_PersistentResourceService.Method.UpdatePersistentResource.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Reboots a PersistentResource.
    public func rebootPersistentResource<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_RebootPersistentResourceRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Longrunning_Operation>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Longrunning_Operation>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_PersistentResourceService.Method.RebootPersistentResource.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
}