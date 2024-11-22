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
// Source: google/cloud/aiplatform/v1/feature_online_store_service.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/grpc/grpc-swift

import GRPCCore
import GRPCProtobuf

public enum Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService {
    public static let descriptor = GRPCCore.ServiceDescriptor.google_cloud_aiplatform_v1_FeatureOnlineStoreService
    public enum Method {
        public enum FetchFeatureValues {
            public typealias Input = Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest
            public typealias Output = Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.descriptor.fullyQualifiedService,
                method: "FetchFeatureValues"
            )
        }
        public enum SearchNearestEntities {
            public typealias Input = Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest
            public typealias Output = Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse
            public static let descriptor = GRPCCore.MethodDescriptor(
                service: Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.descriptor.fullyQualifiedService,
                method: "SearchNearestEntities"
            )
        }
        public static let descriptors: [GRPCCore.MethodDescriptor] = [
            FetchFeatureValues.descriptor,
            SearchNearestEntities.descriptor
        ]
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public typealias ClientProtocol = Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService_ClientProtocol
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public typealias Client = Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService_Client
}

extension GRPCCore.ServiceDescriptor {
    public static let google_cloud_aiplatform_v1_FeatureOnlineStoreService = Self(
        package: "google.cloud.aiplatform.v1",
        service: "FeatureOnlineStoreService"
    )
}

/// A service for fetching feature values from the online store.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public protocol Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService_ClientProtocol: Sendable {
    /// Fetch feature values under a FeatureView.
    func fetchFeatureValues<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>) async throws -> R
    ) async throws -> R where R: Sendable
    
    /// Search the nearest entities under a FeatureView.
    /// Search only works for indexable feature view; if a feature view isn't
    /// indexable, returns Invalid argument response.
    func searchNearestEntities<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>,
        options: GRPCCore.CallOptions,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>) async throws -> R
    ) async throws -> R where R: Sendable
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.ClientProtocol {
    public func fetchFeatureValues<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.fetchFeatureValues(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>(),
            options: options,
            body
        )
    }
    
    public func searchNearestEntities<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.searchNearestEntities(
            request: request,
            serializer: GRPCProtobuf.ProtobufSerializer<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>(),
            deserializer: GRPCProtobuf.ProtobufDeserializer<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>(),
            options: options,
            body
        )
    }
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.ClientProtocol {
    /// Fetch feature values under a FeatureView.
    public func fetchFeatureValues<Result>(
        _ message: Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.fetchFeatureValues(
            request: request,
            options: options,
            handleResponse
        )
    }
    
    /// Search the nearest entities under a FeatureView.
    /// Search only works for indexable feature view; if a feature view isn't
    /// indexable, returns Invalid argument response.
    public func searchNearestEntities<Result>(
        _ message: Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest,
        metadata: GRPCCore.Metadata = [:],
        options: GRPCCore.CallOptions = .defaults,
        onResponse handleResponse: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>) async throws -> Result = {
            try $0.message
        }
    ) async throws -> Result where Result: Sendable {
        let request = GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>(
            message: message,
            metadata: metadata
        )
        return try await self.searchNearestEntities(
            request: request,
            options: options,
            handleResponse
        )
    }
}

/// A service for fetching feature values from the online store.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public struct Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService_Client: Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.ClientProtocol {
    private let client: GRPCCore.GRPCClient
    
    public init(wrapping client: GRPCCore.GRPCClient) {
        self.client = client
    }
    
    /// Fetch feature values under a FeatureView.
    public func fetchFeatureValues<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_FetchFeatureValuesRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_FetchFeatureValuesResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.Method.FetchFeatureValues.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
    
    /// Search the nearest entities under a FeatureView.
    /// Search only works for indexable feature view; if a feature view isn't
    /// indexable, returns Invalid argument response.
    public func searchNearestEntities<R>(
        request: GRPCCore.ClientRequest<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>,
        serializer: some GRPCCore.MessageSerializer<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesRequest>,
        deserializer: some GRPCCore.MessageDeserializer<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>,
        options: GRPCCore.CallOptions = .defaults,
        _ body: @Sendable @escaping (GRPCCore.ClientResponse<Google_Cloud_Aiplatform_V1_SearchNearestEntitiesResponse>) async throws -> R = {
            try $0.message
        }
    ) async throws -> R where R: Sendable {
        try await self.client.unary(
            request: request,
            descriptor: Google_Cloud_Aiplatform_V1_FeatureOnlineStoreService.Method.SearchNearestEntities.descriptor,
            serializer: serializer,
            deserializer: deserializer,
            options: options,
            handler: body
        )
    }
}