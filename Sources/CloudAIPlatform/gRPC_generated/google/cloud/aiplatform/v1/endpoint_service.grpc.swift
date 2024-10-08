//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/endpoint_service.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// A service for managing Vertex AI's Endpoints.
///
/// Usage: instantiate `Google_Cloud_Aiplatform_V1_EndpointServiceClient`, then call methods of this protocol to make API calls.
public protocol Google_Cloud_Aiplatform_V1_EndpointServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? { get }

  func createEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_CreateEndpointRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_CreateEndpointRequest, Google_Longrunning_Operation>

  func getEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_GetEndpointRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_GetEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint>

  func listEndpoints(
    _ request: Google_Cloud_Aiplatform_V1_ListEndpointsRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_ListEndpointsRequest, Google_Cloud_Aiplatform_V1_ListEndpointsResponse>

  func updateEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_UpdateEndpointRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_UpdateEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint>

  func deleteEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_DeleteEndpointRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_DeleteEndpointRequest, Google_Longrunning_Operation>

  func deployModel(
    _ request: Google_Cloud_Aiplatform_V1_DeployModelRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_DeployModelRequest, Google_Longrunning_Operation>

  func undeployModel(
    _ request: Google_Cloud_Aiplatform_V1_UndeployModelRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_UndeployModelRequest, Google_Longrunning_Operation>

  func mutateDeployedModel(
    _ request: Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest, Google_Longrunning_Operation>
}

extension Google_Cloud_Aiplatform_V1_EndpointServiceClientProtocol {
  public var serviceName: String {
    return "google.cloud.aiplatform.v1.EndpointService"
  }

  /// Creates an Endpoint.
  ///
  /// - Parameters:
  ///   - request: Request to send to CreateEndpoint.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func createEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_CreateEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_CreateEndpointRequest, Google_Longrunning_Operation> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.createEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCreateEndpointInterceptors() ?? []
    )
  }

  /// Gets an Endpoint.
  ///
  /// - Parameters:
  ///   - request: Request to send to GetEndpoint.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_GetEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_GetEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.getEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetEndpointInterceptors() ?? []
    )
  }

  /// Lists Endpoints in a Location.
  ///
  /// - Parameters:
  ///   - request: Request to send to ListEndpoints.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func listEndpoints(
    _ request: Google_Cloud_Aiplatform_V1_ListEndpointsRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_ListEndpointsRequest, Google_Cloud_Aiplatform_V1_ListEndpointsResponse> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.listEndpoints.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListEndpointsInterceptors() ?? []
    )
  }

  /// Updates an Endpoint.
  ///
  /// - Parameters:
  ///   - request: Request to send to UpdateEndpoint.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func updateEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_UpdateEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_UpdateEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.updateEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateEndpointInterceptors() ?? []
    )
  }

  /// Deletes an Endpoint.
  ///
  /// - Parameters:
  ///   - request: Request to send to DeleteEndpoint.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func deleteEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_DeleteEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_DeleteEndpointRequest, Google_Longrunning_Operation> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deleteEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteEndpointInterceptors() ?? []
    )
  }

  /// Deploys a Model into this Endpoint, creating a DeployedModel within it.
  ///
  /// - Parameters:
  ///   - request: Request to send to DeployModel.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func deployModel(
    _ request: Google_Cloud_Aiplatform_V1_DeployModelRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_DeployModelRequest, Google_Longrunning_Operation> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deployModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeployModelInterceptors() ?? []
    )
  }

  /// Undeploys a Model from an Endpoint, removing a DeployedModel from it, and
  /// freeing all resources it's using.
  ///
  /// - Parameters:
  ///   - request: Request to send to UndeployModel.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func undeployModel(
    _ request: Google_Cloud_Aiplatform_V1_UndeployModelRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_UndeployModelRequest, Google_Longrunning_Operation> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.undeployModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUndeployModelInterceptors() ?? []
    )
  }

  /// Updates an existing deployed model. Updatable fields include
  /// `min_replica_count`, `max_replica_count`, `autoscaling_metric_specs`,
  /// `disable_container_logging` (v1 only), and `enable_container_logging`
  /// (v1beta1 only).
  ///
  /// - Parameters:
  ///   - request: Request to send to MutateDeployedModel.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func mutateDeployedModel(
    _ request: Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest, Google_Longrunning_Operation> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.mutateDeployedModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeMutateDeployedModelInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Google_Cloud_Aiplatform_V1_EndpointServiceClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Google_Cloud_Aiplatform_V1_EndpointServiceNIOClient")
public final class Google_Cloud_Aiplatform_V1_EndpointServiceClient: Google_Cloud_Aiplatform_V1_EndpointServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the google.cloud.aiplatform.v1.EndpointService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Google_Cloud_Aiplatform_V1_EndpointServiceNIOClient: Google_Cloud_Aiplatform_V1_EndpointServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the google.cloud.aiplatform.v1.EndpointService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// A service for managing Vertex AI's Endpoints.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Google_Cloud_Aiplatform_V1_EndpointServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? { get }

  func makeCreateEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_CreateEndpointRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_CreateEndpointRequest, Google_Longrunning_Operation>

  func makeGetEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_GetEndpointRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_GetEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint>

  func makeListEndpointsCall(
    _ request: Google_Cloud_Aiplatform_V1_ListEndpointsRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_ListEndpointsRequest, Google_Cloud_Aiplatform_V1_ListEndpointsResponse>

  func makeUpdateEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_UpdateEndpointRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_UpdateEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint>

  func makeDeleteEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_DeleteEndpointRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_DeleteEndpointRequest, Google_Longrunning_Operation>

  func makeDeployModelCall(
    _ request: Google_Cloud_Aiplatform_V1_DeployModelRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_DeployModelRequest, Google_Longrunning_Operation>

  func makeUndeployModelCall(
    _ request: Google_Cloud_Aiplatform_V1_UndeployModelRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_UndeployModelRequest, Google_Longrunning_Operation>

  func makeMutateDeployedModelCall(
    _ request: Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest, Google_Longrunning_Operation>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Google_Cloud_Aiplatform_V1_EndpointServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeCreateEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_CreateEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_CreateEndpointRequest, Google_Longrunning_Operation> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.createEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCreateEndpointInterceptors() ?? []
    )
  }

  public func makeGetEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_GetEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_GetEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.getEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetEndpointInterceptors() ?? []
    )
  }

  public func makeListEndpointsCall(
    _ request: Google_Cloud_Aiplatform_V1_ListEndpointsRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_ListEndpointsRequest, Google_Cloud_Aiplatform_V1_ListEndpointsResponse> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.listEndpoints.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListEndpointsInterceptors() ?? []
    )
  }

  public func makeUpdateEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_UpdateEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_UpdateEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.updateEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateEndpointInterceptors() ?? []
    )
  }

  public func makeDeleteEndpointCall(
    _ request: Google_Cloud_Aiplatform_V1_DeleteEndpointRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_DeleteEndpointRequest, Google_Longrunning_Operation> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deleteEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteEndpointInterceptors() ?? []
    )
  }

  public func makeDeployModelCall(
    _ request: Google_Cloud_Aiplatform_V1_DeployModelRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_DeployModelRequest, Google_Longrunning_Operation> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deployModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeployModelInterceptors() ?? []
    )
  }

  public func makeUndeployModelCall(
    _ request: Google_Cloud_Aiplatform_V1_UndeployModelRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_UndeployModelRequest, Google_Longrunning_Operation> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.undeployModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUndeployModelInterceptors() ?? []
    )
  }

  public func makeMutateDeployedModelCall(
    _ request: Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest, Google_Longrunning_Operation> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.mutateDeployedModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeMutateDeployedModelInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Google_Cloud_Aiplatform_V1_EndpointServiceAsyncClientProtocol {
  public func createEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_CreateEndpointRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Longrunning_Operation {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.createEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCreateEndpointInterceptors() ?? []
    )
  }

  public func getEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_GetEndpointRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_Endpoint {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.getEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetEndpointInterceptors() ?? []
    )
  }

  public func listEndpoints(
    _ request: Google_Cloud_Aiplatform_V1_ListEndpointsRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_ListEndpointsResponse {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.listEndpoints.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListEndpointsInterceptors() ?? []
    )
  }

  public func updateEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_UpdateEndpointRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_Endpoint {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.updateEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateEndpointInterceptors() ?? []
    )
  }

  public func deleteEndpoint(
    _ request: Google_Cloud_Aiplatform_V1_DeleteEndpointRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Longrunning_Operation {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deleteEndpoint.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteEndpointInterceptors() ?? []
    )
  }

  public func deployModel(
    _ request: Google_Cloud_Aiplatform_V1_DeployModelRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Longrunning_Operation {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deployModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeployModelInterceptors() ?? []
    )
  }

  public func undeployModel(
    _ request: Google_Cloud_Aiplatform_V1_UndeployModelRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Longrunning_Operation {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.undeployModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUndeployModelInterceptors() ?? []
    )
  }

  public func mutateDeployedModel(
    _ request: Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Longrunning_Operation {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.mutateDeployedModel.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeMutateDeployedModelInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Google_Cloud_Aiplatform_V1_EndpointServiceAsyncClient: Google_Cloud_Aiplatform_V1_EndpointServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Google_Cloud_Aiplatform_V1_EndpointServiceClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'createEndpoint'.
  func makeCreateEndpointInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_CreateEndpointRequest, Google_Longrunning_Operation>]

  /// - Returns: Interceptors to use when invoking 'getEndpoint'.
  func makeGetEndpointInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_GetEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint>]

  /// - Returns: Interceptors to use when invoking 'listEndpoints'.
  func makeListEndpointsInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_ListEndpointsRequest, Google_Cloud_Aiplatform_V1_ListEndpointsResponse>]

  /// - Returns: Interceptors to use when invoking 'updateEndpoint'.
  func makeUpdateEndpointInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_UpdateEndpointRequest, Google_Cloud_Aiplatform_V1_Endpoint>]

  /// - Returns: Interceptors to use when invoking 'deleteEndpoint'.
  func makeDeleteEndpointInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_DeleteEndpointRequest, Google_Longrunning_Operation>]

  /// - Returns: Interceptors to use when invoking 'deployModel'.
  func makeDeployModelInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_DeployModelRequest, Google_Longrunning_Operation>]

  /// - Returns: Interceptors to use when invoking 'undeployModel'.
  func makeUndeployModelInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_UndeployModelRequest, Google_Longrunning_Operation>]

  /// - Returns: Interceptors to use when invoking 'mutateDeployedModel'.
  func makeMutateDeployedModelInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_MutateDeployedModelRequest, Google_Longrunning_Operation>]
}

public enum Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "EndpointService",
    fullName: "google.cloud.aiplatform.v1.EndpointService",
    methods: [
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.createEndpoint,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.getEndpoint,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.listEndpoints,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.updateEndpoint,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deleteEndpoint,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.deployModel,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.undeployModel,
      Google_Cloud_Aiplatform_V1_EndpointServiceClientMetadata.Methods.mutateDeployedModel,
    ]
  )

  public enum Methods {
    public static let createEndpoint = GRPCMethodDescriptor(
      name: "CreateEndpoint",
      path: "/google.cloud.aiplatform.v1.EndpointService/CreateEndpoint",
      type: GRPCCallType.unary
    )

    public static let getEndpoint = GRPCMethodDescriptor(
      name: "GetEndpoint",
      path: "/google.cloud.aiplatform.v1.EndpointService/GetEndpoint",
      type: GRPCCallType.unary
    )

    public static let listEndpoints = GRPCMethodDescriptor(
      name: "ListEndpoints",
      path: "/google.cloud.aiplatform.v1.EndpointService/ListEndpoints",
      type: GRPCCallType.unary
    )

    public static let updateEndpoint = GRPCMethodDescriptor(
      name: "UpdateEndpoint",
      path: "/google.cloud.aiplatform.v1.EndpointService/UpdateEndpoint",
      type: GRPCCallType.unary
    )

    public static let deleteEndpoint = GRPCMethodDescriptor(
      name: "DeleteEndpoint",
      path: "/google.cloud.aiplatform.v1.EndpointService/DeleteEndpoint",
      type: GRPCCallType.unary
    )

    public static let deployModel = GRPCMethodDescriptor(
      name: "DeployModel",
      path: "/google.cloud.aiplatform.v1.EndpointService/DeployModel",
      type: GRPCCallType.unary
    )

    public static let undeployModel = GRPCMethodDescriptor(
      name: "UndeployModel",
      path: "/google.cloud.aiplatform.v1.EndpointService/UndeployModel",
      type: GRPCCallType.unary
    )

    public static let mutateDeployedModel = GRPCMethodDescriptor(
      name: "MutateDeployedModel",
      path: "/google.cloud.aiplatform.v1.EndpointService/MutateDeployedModel",
      type: GRPCCallType.unary
    )
  }
}

