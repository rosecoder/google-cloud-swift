//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/evaluation_service.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// Vertex AI Online Evaluation Service.
///
/// Usage: instantiate `Google_Cloud_Aiplatform_V1_EvaluationServiceClient`, then call methods of this protocol to make API calls.
public protocol Google_Cloud_Aiplatform_V1_EvaluationServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? { get }

  func evaluateInstances(
    _ request: Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest, Google_Cloud_Aiplatform_V1_EvaluateInstancesResponse>
}

extension Google_Cloud_Aiplatform_V1_EvaluationServiceClientProtocol {
  public var serviceName: String {
    return "google.cloud.aiplatform.v1.EvaluationService"
  }

  /// Evaluates instances based on a given metric.
  ///
  /// - Parameters:
  ///   - request: Request to send to EvaluateInstances.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func evaluateInstances(
    _ request: Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest, Google_Cloud_Aiplatform_V1_EvaluateInstancesResponse> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EvaluationServiceClientMetadata.Methods.evaluateInstances.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeEvaluateInstancesInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Google_Cloud_Aiplatform_V1_EvaluationServiceClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Google_Cloud_Aiplatform_V1_EvaluationServiceNIOClient")
public final class Google_Cloud_Aiplatform_V1_EvaluationServiceClient: Google_Cloud_Aiplatform_V1_EvaluationServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the google.cloud.aiplatform.v1.EvaluationService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Google_Cloud_Aiplatform_V1_EvaluationServiceNIOClient: Google_Cloud_Aiplatform_V1_EvaluationServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the google.cloud.aiplatform.v1.EvaluationService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Vertex AI Online Evaluation Service.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Google_Cloud_Aiplatform_V1_EvaluationServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? { get }

  func makeEvaluateInstancesCall(
    _ request: Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest, Google_Cloud_Aiplatform_V1_EvaluateInstancesResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Google_Cloud_Aiplatform_V1_EvaluationServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Google_Cloud_Aiplatform_V1_EvaluationServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeEvaluateInstancesCall(
    _ request: Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest, Google_Cloud_Aiplatform_V1_EvaluateInstancesResponse> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EvaluationServiceClientMetadata.Methods.evaluateInstances.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeEvaluateInstancesInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Google_Cloud_Aiplatform_V1_EvaluationServiceAsyncClientProtocol {
  public func evaluateInstances(
    _ request: Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_EvaluateInstancesResponse {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_EvaluationServiceClientMetadata.Methods.evaluateInstances.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeEvaluateInstancesInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Google_Cloud_Aiplatform_V1_EvaluationServiceAsyncClient: Google_Cloud_Aiplatform_V1_EvaluationServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Google_Cloud_Aiplatform_V1_EvaluationServiceClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'evaluateInstances'.
  func makeEvaluateInstancesInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_EvaluateInstancesRequest, Google_Cloud_Aiplatform_V1_EvaluateInstancesResponse>]
}

public enum Google_Cloud_Aiplatform_V1_EvaluationServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "EvaluationService",
    fullName: "google.cloud.aiplatform.v1.EvaluationService",
    methods: [
      Google_Cloud_Aiplatform_V1_EvaluationServiceClientMetadata.Methods.evaluateInstances,
    ]
  )

  public enum Methods {
    public static let evaluateInstances = GRPCMethodDescriptor(
      name: "EvaluateInstances",
      path: "/google.cloud.aiplatform.v1.EvaluationService/EvaluateInstances",
      type: GRPCCallType.unary
    )
  }
}
