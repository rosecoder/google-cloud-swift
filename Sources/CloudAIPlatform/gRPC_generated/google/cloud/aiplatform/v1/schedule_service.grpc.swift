//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/schedule_service.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// A service for creating and managing Vertex AI's Schedule resources to
/// periodically launch shceudled runs to make API calls.
///
/// Usage: instantiate `Google_Cloud_Aiplatform_V1_ScheduleServiceClient`, then call methods of this protocol to make API calls.
public protocol Google_Cloud_Aiplatform_V1_ScheduleServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? { get }

  func createSchedule(
    _ request: Google_Cloud_Aiplatform_V1_CreateScheduleRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_CreateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>

  func deleteSchedule(
    _ request: Google_Cloud_Aiplatform_V1_DeleteScheduleRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_DeleteScheduleRequest, Google_Longrunning_Operation>

  func getSchedule(
    _ request: Google_Cloud_Aiplatform_V1_GetScheduleRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_GetScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>

  func listSchedules(
    _ request: Google_Cloud_Aiplatform_V1_ListSchedulesRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_ListSchedulesRequest, Google_Cloud_Aiplatform_V1_ListSchedulesResponse>

  func pauseSchedule(
    _ request: Google_Cloud_Aiplatform_V1_PauseScheduleRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_PauseScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty>

  func resumeSchedule(
    _ request: Google_Cloud_Aiplatform_V1_ResumeScheduleRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_ResumeScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty>

  func updateSchedule(
    _ request: Google_Cloud_Aiplatform_V1_UpdateScheduleRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_UpdateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>
}

extension Google_Cloud_Aiplatform_V1_ScheduleServiceClientProtocol {
  public var serviceName: String {
    return "google.cloud.aiplatform.v1.ScheduleService"
  }

  /// Creates a Schedule.
  ///
  /// - Parameters:
  ///   - request: Request to send to CreateSchedule.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func createSchedule(
    _ request: Google_Cloud_Aiplatform_V1_CreateScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_CreateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.createSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCreateScheduleInterceptors() ?? []
    )
  }

  /// Deletes a Schedule.
  ///
  /// - Parameters:
  ///   - request: Request to send to DeleteSchedule.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func deleteSchedule(
    _ request: Google_Cloud_Aiplatform_V1_DeleteScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_DeleteScheduleRequest, Google_Longrunning_Operation> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.deleteSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteScheduleInterceptors() ?? []
    )
  }

  /// Gets a Schedule.
  ///
  /// - Parameters:
  ///   - request: Request to send to GetSchedule.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getSchedule(
    _ request: Google_Cloud_Aiplatform_V1_GetScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_GetScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.getSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetScheduleInterceptors() ?? []
    )
  }

  /// Lists Schedules in a Location.
  ///
  /// - Parameters:
  ///   - request: Request to send to ListSchedules.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func listSchedules(
    _ request: Google_Cloud_Aiplatform_V1_ListSchedulesRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_ListSchedulesRequest, Google_Cloud_Aiplatform_V1_ListSchedulesResponse> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.listSchedules.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListSchedulesInterceptors() ?? []
    )
  }

  /// Pauses a Schedule. Will mark
  /// [Schedule.state][google.cloud.aiplatform.v1.Schedule.state] to 'PAUSED'. If
  /// the schedule is paused, no new runs will be created. Already created runs
  /// will NOT be paused or canceled.
  ///
  /// - Parameters:
  ///   - request: Request to send to PauseSchedule.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func pauseSchedule(
    _ request: Google_Cloud_Aiplatform_V1_PauseScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_PauseScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.pauseSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePauseScheduleInterceptors() ?? []
    )
  }

  /// Resumes a paused Schedule to start scheduling new runs. Will mark
  /// [Schedule.state][google.cloud.aiplatform.v1.Schedule.state] to 'ACTIVE'.
  /// Only paused Schedule can be resumed.
  ///
  /// When the Schedule is resumed, new runs will be scheduled starting from the
  /// next execution time after the current time based on the time_specification
  /// in the Schedule. If [Schedule.catchUp][] is set up true, all
  /// missed runs will be scheduled for backfill first.
  ///
  /// - Parameters:
  ///   - request: Request to send to ResumeSchedule.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func resumeSchedule(
    _ request: Google_Cloud_Aiplatform_V1_ResumeScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_ResumeScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.resumeSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeResumeScheduleInterceptors() ?? []
    )
  }

  /// Updates an active or paused Schedule.
  ///
  /// When the Schedule is updated, new runs will be scheduled starting from the
  /// updated next execution time after the update time based on the
  /// time_specification in the updated Schedule. All unstarted runs before the
  /// update time will be skipped while already created runs will NOT be paused
  /// or canceled.
  ///
  /// - Parameters:
  ///   - request: Request to send to UpdateSchedule.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func updateSchedule(
    _ request: Google_Cloud_Aiplatform_V1_UpdateScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Google_Cloud_Aiplatform_V1_UpdateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule> {
    return self.makeUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.updateSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateScheduleInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Google_Cloud_Aiplatform_V1_ScheduleServiceClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Google_Cloud_Aiplatform_V1_ScheduleServiceNIOClient")
public final class Google_Cloud_Aiplatform_V1_ScheduleServiceClient: Google_Cloud_Aiplatform_V1_ScheduleServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the google.cloud.aiplatform.v1.ScheduleService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Google_Cloud_Aiplatform_V1_ScheduleServiceNIOClient: Google_Cloud_Aiplatform_V1_ScheduleServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the google.cloud.aiplatform.v1.ScheduleService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// A service for creating and managing Vertex AI's Schedule resources to
/// periodically launch shceudled runs to make API calls.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Google_Cloud_Aiplatform_V1_ScheduleServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? { get }

  func makeCreateScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_CreateScheduleRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_CreateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>

  func makeDeleteScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_DeleteScheduleRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_DeleteScheduleRequest, Google_Longrunning_Operation>

  func makeGetScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_GetScheduleRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_GetScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>

  func makeListSchedulesCall(
    _ request: Google_Cloud_Aiplatform_V1_ListSchedulesRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_ListSchedulesRequest, Google_Cloud_Aiplatform_V1_ListSchedulesResponse>

  func makePauseScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_PauseScheduleRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_PauseScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty>

  func makeResumeScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_ResumeScheduleRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_ResumeScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty>

  func makeUpdateScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_UpdateScheduleRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_UpdateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Google_Cloud_Aiplatform_V1_ScheduleServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeCreateScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_CreateScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_CreateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.createSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCreateScheduleInterceptors() ?? []
    )
  }

  public func makeDeleteScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_DeleteScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_DeleteScheduleRequest, Google_Longrunning_Operation> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.deleteSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteScheduleInterceptors() ?? []
    )
  }

  public func makeGetScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_GetScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_GetScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.getSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetScheduleInterceptors() ?? []
    )
  }

  public func makeListSchedulesCall(
    _ request: Google_Cloud_Aiplatform_V1_ListSchedulesRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_ListSchedulesRequest, Google_Cloud_Aiplatform_V1_ListSchedulesResponse> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.listSchedules.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListSchedulesInterceptors() ?? []
    )
  }

  public func makePauseScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_PauseScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_PauseScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.pauseSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePauseScheduleInterceptors() ?? []
    )
  }

  public func makeResumeScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_ResumeScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_ResumeScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.resumeSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeResumeScheduleInterceptors() ?? []
    )
  }

  public func makeUpdateScheduleCall(
    _ request: Google_Cloud_Aiplatform_V1_UpdateScheduleRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Google_Cloud_Aiplatform_V1_UpdateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule> {
    return self.makeAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.updateSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateScheduleInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Google_Cloud_Aiplatform_V1_ScheduleServiceAsyncClientProtocol {
  public func createSchedule(
    _ request: Google_Cloud_Aiplatform_V1_CreateScheduleRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_Schedule {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.createSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCreateScheduleInterceptors() ?? []
    )
  }

  public func deleteSchedule(
    _ request: Google_Cloud_Aiplatform_V1_DeleteScheduleRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Longrunning_Operation {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.deleteSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteScheduleInterceptors() ?? []
    )
  }

  public func getSchedule(
    _ request: Google_Cloud_Aiplatform_V1_GetScheduleRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_Schedule {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.getSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetScheduleInterceptors() ?? []
    )
  }

  public func listSchedules(
    _ request: Google_Cloud_Aiplatform_V1_ListSchedulesRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_ListSchedulesResponse {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.listSchedules.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListSchedulesInterceptors() ?? []
    )
  }

  public func pauseSchedule(
    _ request: Google_Cloud_Aiplatform_V1_PauseScheduleRequest,
    callOptions: CallOptions? = nil
  ) async throws -> SwiftProtobuf.Google_Protobuf_Empty {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.pauseSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePauseScheduleInterceptors() ?? []
    )
  }

  public func resumeSchedule(
    _ request: Google_Cloud_Aiplatform_V1_ResumeScheduleRequest,
    callOptions: CallOptions? = nil
  ) async throws -> SwiftProtobuf.Google_Protobuf_Empty {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.resumeSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeResumeScheduleInterceptors() ?? []
    )
  }

  public func updateSchedule(
    _ request: Google_Cloud_Aiplatform_V1_UpdateScheduleRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Google_Cloud_Aiplatform_V1_Schedule {
    return try await self.performAsyncUnaryCall(
      path: Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.updateSchedule.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeUpdateScheduleInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Google_Cloud_Aiplatform_V1_ScheduleServiceAsyncClient: Google_Cloud_Aiplatform_V1_ScheduleServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Google_Cloud_Aiplatform_V1_ScheduleServiceClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'createSchedule'.
  func makeCreateScheduleInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_CreateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>]

  /// - Returns: Interceptors to use when invoking 'deleteSchedule'.
  func makeDeleteScheduleInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_DeleteScheduleRequest, Google_Longrunning_Operation>]

  /// - Returns: Interceptors to use when invoking 'getSchedule'.
  func makeGetScheduleInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_GetScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>]

  /// - Returns: Interceptors to use when invoking 'listSchedules'.
  func makeListSchedulesInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_ListSchedulesRequest, Google_Cloud_Aiplatform_V1_ListSchedulesResponse>]

  /// - Returns: Interceptors to use when invoking 'pauseSchedule'.
  func makePauseScheduleInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_PauseScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty>]

  /// - Returns: Interceptors to use when invoking 'resumeSchedule'.
  func makeResumeScheduleInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_ResumeScheduleRequest, SwiftProtobuf.Google_Protobuf_Empty>]

  /// - Returns: Interceptors to use when invoking 'updateSchedule'.
  func makeUpdateScheduleInterceptors() -> [ClientInterceptor<Google_Cloud_Aiplatform_V1_UpdateScheduleRequest, Google_Cloud_Aiplatform_V1_Schedule>]
}

public enum Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "ScheduleService",
    fullName: "google.cloud.aiplatform.v1.ScheduleService",
    methods: [
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.createSchedule,
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.deleteSchedule,
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.getSchedule,
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.listSchedules,
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.pauseSchedule,
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.resumeSchedule,
      Google_Cloud_Aiplatform_V1_ScheduleServiceClientMetadata.Methods.updateSchedule,
    ]
  )

  public enum Methods {
    public static let createSchedule = GRPCMethodDescriptor(
      name: "CreateSchedule",
      path: "/google.cloud.aiplatform.v1.ScheduleService/CreateSchedule",
      type: GRPCCallType.unary
    )

    public static let deleteSchedule = GRPCMethodDescriptor(
      name: "DeleteSchedule",
      path: "/google.cloud.aiplatform.v1.ScheduleService/DeleteSchedule",
      type: GRPCCallType.unary
    )

    public static let getSchedule = GRPCMethodDescriptor(
      name: "GetSchedule",
      path: "/google.cloud.aiplatform.v1.ScheduleService/GetSchedule",
      type: GRPCCallType.unary
    )

    public static let listSchedules = GRPCMethodDescriptor(
      name: "ListSchedules",
      path: "/google.cloud.aiplatform.v1.ScheduleService/ListSchedules",
      type: GRPCCallType.unary
    )

    public static let pauseSchedule = GRPCMethodDescriptor(
      name: "PauseSchedule",
      path: "/google.cloud.aiplatform.v1.ScheduleService/PauseSchedule",
      type: GRPCCallType.unary
    )

    public static let resumeSchedule = GRPCMethodDescriptor(
      name: "ResumeSchedule",
      path: "/google.cloud.aiplatform.v1.ScheduleService/ResumeSchedule",
      type: GRPCCallType.unary
    )

    public static let updateSchedule = GRPCMethodDescriptor(
      name: "UpdateSchedule",
      path: "/google.cloud.aiplatform.v1.ScheduleService/UpdateSchedule",
      type: GRPCCallType.unary
    )
  }
}

