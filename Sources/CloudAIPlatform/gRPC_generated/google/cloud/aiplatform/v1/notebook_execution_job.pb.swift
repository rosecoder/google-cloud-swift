// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/notebook_execution_job.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

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

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// NotebookExecutionJob represents an instance of a notebook execution.
public struct Google_Cloud_Aiplatform_V1_NotebookExecutionJob: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The input notebook.
  public var notebookSource: OneOf_NotebookSource? {
    get {return _storage._notebookSource}
    set {_uniqueStorage()._notebookSource = newValue}
  }

  /// The Dataform Repository pointing to a single file notebook repository.
  public var dataformRepositorySource: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource {
    get {
      if case .dataformRepositorySource(let v)? = _storage._notebookSource {return v}
      return Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource()
    }
    set {_uniqueStorage()._notebookSource = .dataformRepositorySource(newValue)}
  }

  /// The Cloud Storage url pointing to the ipynb file. Format:
  /// `gs://bucket/notebook_file.ipynb`
  public var gcsNotebookSource: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource {
    get {
      if case .gcsNotebookSource(let v)? = _storage._notebookSource {return v}
      return Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource()
    }
    set {_uniqueStorage()._notebookSource = .gcsNotebookSource(newValue)}
  }

  /// The contents of an input notebook file.
  public var directNotebookSource: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource {
    get {
      if case .directNotebookSource(let v)? = _storage._notebookSource {return v}
      return Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource()
    }
    set {_uniqueStorage()._notebookSource = .directNotebookSource(newValue)}
  }

  /// The compute config to use for an execution job.
  public var environmentSpec: OneOf_EnvironmentSpec? {
    get {return _storage._environmentSpec}
    set {_uniqueStorage()._environmentSpec = newValue}
  }

  /// The NotebookRuntimeTemplate to source compute configuration from.
  public var notebookRuntimeTemplateResourceName: String {
    get {
      if case .notebookRuntimeTemplateResourceName(let v)? = _storage._environmentSpec {return v}
      return String()
    }
    set {_uniqueStorage()._environmentSpec = .notebookRuntimeTemplateResourceName(newValue)}
  }

  /// The location to store the notebook execution result.
  public var executionSink: OneOf_ExecutionSink? {
    get {return _storage._executionSink}
    set {_uniqueStorage()._executionSink = newValue}
  }

  /// The Cloud Storage location to upload the result to. Format:
  /// `gs://bucket-name`
  public var gcsOutputUri: String {
    get {
      if case .gcsOutputUri(let v)? = _storage._executionSink {return v}
      return String()
    }
    set {_uniqueStorage()._executionSink = .gcsOutputUri(newValue)}
  }

  /// The identity to run the execution as.
  public var executionIdentity: OneOf_ExecutionIdentity? {
    get {return _storage._executionIdentity}
    set {_uniqueStorage()._executionIdentity = newValue}
  }

  /// The user email to run the execution as. Only supported by Colab runtimes.
  public var executionUser: String {
    get {
      if case .executionUser(let v)? = _storage._executionIdentity {return v}
      return String()
    }
    set {_uniqueStorage()._executionIdentity = .executionUser(newValue)}
  }

  /// The service account to run the execution as.
  public var serviceAccount: String {
    get {
      if case .serviceAccount(let v)? = _storage._executionIdentity {return v}
      return String()
    }
    set {_uniqueStorage()._executionIdentity = .serviceAccount(newValue)}
  }

  /// Output only. The resource name of this NotebookExecutionJob. Format:
  /// `projects/{project_id}/locations/{location}/notebookExecutionJobs/{job_id}`
  public var name: String {
    get {return _storage._name}
    set {_uniqueStorage()._name = newValue}
  }

  /// The display name of the NotebookExecutionJob. The name can be up to 128
  /// characters long and can consist of any UTF-8 characters.
  public var displayName: String {
    get {return _storage._displayName}
    set {_uniqueStorage()._displayName = newValue}
  }

  /// Max running time of the execution job in seconds (default 86400s / 24 hrs).
  public var executionTimeout: SwiftProtobuf.Google_Protobuf_Duration {
    get {return _storage._executionTimeout ?? SwiftProtobuf.Google_Protobuf_Duration()}
    set {_uniqueStorage()._executionTimeout = newValue}
  }
  /// Returns true if `executionTimeout` has been explicitly set.
  public var hasExecutionTimeout: Bool {return _storage._executionTimeout != nil}
  /// Clears the value of `executionTimeout`. Subsequent reads from it will return its default value.
  public mutating func clearExecutionTimeout() {_uniqueStorage()._executionTimeout = nil}

  /// Output only. The Schedule resource name if this job is triggered by one.
  /// Format:
  /// `projects/{project_id}/locations/{location}/schedules/{schedule_id}`
  public var scheduleResourceName: String {
    get {return _storage._scheduleResourceName}
    set {_uniqueStorage()._scheduleResourceName = newValue}
  }

  /// Output only. The state of the NotebookExecutionJob.
  public var jobState: Google_Cloud_Aiplatform_V1_JobState {
    get {return _storage._jobState}
    set {_uniqueStorage()._jobState = newValue}
  }

  /// Output only. Populated when the NotebookExecutionJob is completed. When
  /// there is an error during notebook execution, the error details are
  /// populated.
  public var status: Google_Rpc_Status {
    get {return _storage._status ?? Google_Rpc_Status()}
    set {_uniqueStorage()._status = newValue}
  }
  /// Returns true if `status` has been explicitly set.
  public var hasStatus: Bool {return _storage._status != nil}
  /// Clears the value of `status`. Subsequent reads from it will return its default value.
  public mutating func clearStatus() {_uniqueStorage()._status = nil}

  /// Output only. Timestamp when this NotebookExecutionJob was created.
  public var createTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._createTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._createTime = newValue}
  }
  /// Returns true if `createTime` has been explicitly set.
  public var hasCreateTime: Bool {return _storage._createTime != nil}
  /// Clears the value of `createTime`. Subsequent reads from it will return its default value.
  public mutating func clearCreateTime() {_uniqueStorage()._createTime = nil}

  /// Output only. Timestamp when this NotebookExecutionJob was most recently
  /// updated.
  public var updateTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._updateTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._updateTime = newValue}
  }
  /// Returns true if `updateTime` has been explicitly set.
  public var hasUpdateTime: Bool {return _storage._updateTime != nil}
  /// Clears the value of `updateTime`. Subsequent reads from it will return its default value.
  public mutating func clearUpdateTime() {_uniqueStorage()._updateTime = nil}

  /// The labels with user-defined metadata to organize NotebookExecutionJobs.
  ///
  /// Label keys and values can be no longer than 64 characters
  /// (Unicode codepoints), can only contain lowercase letters, numeric
  /// characters, underscores and dashes. International characters are allowed.
  ///
  /// See https://goo.gl/xmQnxf for more information and examples of labels.
  /// System reserved label keys are prefixed with "aiplatform.googleapis.com/"
  /// and are immutable.
  public var labels: Dictionary<String,String> {
    get {return _storage._labels}
    set {_uniqueStorage()._labels = newValue}
  }

  /// Customer-managed encryption key spec for the notebook execution job.
  /// This field is auto-populated if the
  /// [NotebookService.NotebookRuntimeTemplate][] has an encryption spec.
  public var encryptionSpec: Google_Cloud_Aiplatform_V1_EncryptionSpec {
    get {return _storage._encryptionSpec ?? Google_Cloud_Aiplatform_V1_EncryptionSpec()}
    set {_uniqueStorage()._encryptionSpec = newValue}
  }
  /// Returns true if `encryptionSpec` has been explicitly set.
  public var hasEncryptionSpec: Bool {return _storage._encryptionSpec != nil}
  /// Clears the value of `encryptionSpec`. Subsequent reads from it will return its default value.
  public mutating func clearEncryptionSpec() {_uniqueStorage()._encryptionSpec = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// The input notebook.
  public enum OneOf_NotebookSource: Equatable, Sendable {
    /// The Dataform Repository pointing to a single file notebook repository.
    case dataformRepositorySource(Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource)
    /// The Cloud Storage url pointing to the ipynb file. Format:
    /// `gs://bucket/notebook_file.ipynb`
    case gcsNotebookSource(Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource)
    /// The contents of an input notebook file.
    case directNotebookSource(Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource)

  }

  /// The compute config to use for an execution job.
  public enum OneOf_EnvironmentSpec: Equatable, Sendable {
    /// The NotebookRuntimeTemplate to source compute configuration from.
    case notebookRuntimeTemplateResourceName(String)

  }

  /// The location to store the notebook execution result.
  public enum OneOf_ExecutionSink: Equatable, Sendable {
    /// The Cloud Storage location to upload the result to. Format:
    /// `gs://bucket-name`
    case gcsOutputUri(String)

  }

  /// The identity to run the execution as.
  public enum OneOf_ExecutionIdentity: Equatable, Sendable {
    /// The user email to run the execution as. Only supported by Colab runtimes.
    case executionUser(String)
    /// The service account to run the execution as.
    case serviceAccount(String)

  }

  /// The Dataform Repository containing the input notebook.
  public struct DataformRepositorySource: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// The resource name of the Dataform Repository. Format:
    /// `projects/{project_id}/locations/{location}/repositories/{repository_id}`
    public var dataformRepositoryResourceName: String = String()

    /// The commit SHA to read repository with. If unset, the file will be read
    /// at HEAD.
    public var commitSha: String = String()

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}
  }

  /// The Cloud Storage uri for the input notebook.
  public struct GcsNotebookSource: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// The Cloud Storage uri pointing to the ipynb file. Format:
    /// `gs://bucket/notebook_file.ipynb`
    public var uri: String = String()

    /// The version of the Cloud Storage object to read. If unset, the current
    /// version of the object is read. See
    /// https://cloud.google.com/storage/docs/metadata#generation-number.
    public var generation: String = String()

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}
  }

  /// The content of the input notebook in ipynb format.
  public struct DirectNotebookSource: @unchecked Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// The base64-encoded contents of the input notebook file.
    public var content: Data = Data()

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}
  }

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_NotebookExecutionJob: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".NotebookExecutionJob"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    3: .standard(proto: "dataform_repository_source"),
    4: .standard(proto: "gcs_notebook_source"),
    17: .standard(proto: "direct_notebook_source"),
    14: .standard(proto: "notebook_runtime_template_resource_name"),
    8: .standard(proto: "gcs_output_uri"),
    9: .standard(proto: "execution_user"),
    18: .standard(proto: "service_account"),
    1: .same(proto: "name"),
    2: .standard(proto: "display_name"),
    5: .standard(proto: "execution_timeout"),
    6: .standard(proto: "schedule_resource_name"),
    10: .standard(proto: "job_state"),
    11: .same(proto: "status"),
    12: .standard(proto: "create_time"),
    13: .standard(proto: "update_time"),
    19: .same(proto: "labels"),
    22: .standard(proto: "encryption_spec"),
  ]

  fileprivate class _StorageClass {
    var _notebookSource: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.OneOf_NotebookSource?
    var _environmentSpec: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.OneOf_EnvironmentSpec?
    var _executionSink: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.OneOf_ExecutionSink?
    var _executionIdentity: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.OneOf_ExecutionIdentity?
    var _name: String = String()
    var _displayName: String = String()
    var _executionTimeout: SwiftProtobuf.Google_Protobuf_Duration? = nil
    var _scheduleResourceName: String = String()
    var _jobState: Google_Cloud_Aiplatform_V1_JobState = .unspecified
    var _status: Google_Rpc_Status? = nil
    var _createTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _updateTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _labels: Dictionary<String,String> = [:]
    var _encryptionSpec: Google_Cloud_Aiplatform_V1_EncryptionSpec? = nil

    #if swift(>=5.10)
      // This property is used as the initial default value for new instances of the type.
      // The type itself is protecting the reference to its storage via CoW semantics.
      // This will force a copy to be made of this reference when the first mutation occurs;
      // hence, it is safe to mark this as `nonisolated(unsafe)`.
      static nonisolated(unsafe) let defaultInstance = _StorageClass()
    #else
      static let defaultInstance = _StorageClass()
    #endif

    private init() {}

    init(copying source: _StorageClass) {
      _notebookSource = source._notebookSource
      _environmentSpec = source._environmentSpec
      _executionSink = source._executionSink
      _executionIdentity = source._executionIdentity
      _name = source._name
      _displayName = source._displayName
      _executionTimeout = source._executionTimeout
      _scheduleResourceName = source._scheduleResourceName
      _jobState = source._jobState
      _status = source._status
      _createTime = source._createTime
      _updateTime = source._updateTime
      _labels = source._labels
      _encryptionSpec = source._encryptionSpec
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularStringField(value: &_storage._name) }()
        case 2: try { try decoder.decodeSingularStringField(value: &_storage._displayName) }()
        case 3: try {
          var v: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource?
          var hadOneofValue = false
          if let current = _storage._notebookSource {
            hadOneofValue = true
            if case .dataformRepositorySource(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {
            if hadOneofValue {try decoder.handleConflictingOneOf()}
            _storage._notebookSource = .dataformRepositorySource(v)
          }
        }()
        case 4: try {
          var v: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource?
          var hadOneofValue = false
          if let current = _storage._notebookSource {
            hadOneofValue = true
            if case .gcsNotebookSource(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {
            if hadOneofValue {try decoder.handleConflictingOneOf()}
            _storage._notebookSource = .gcsNotebookSource(v)
          }
        }()
        case 5: try { try decoder.decodeSingularMessageField(value: &_storage._executionTimeout) }()
        case 6: try { try decoder.decodeSingularStringField(value: &_storage._scheduleResourceName) }()
        case 8: try {
          var v: String?
          try decoder.decodeSingularStringField(value: &v)
          if let v = v {
            if _storage._executionSink != nil {try decoder.handleConflictingOneOf()}
            _storage._executionSink = .gcsOutputUri(v)
          }
        }()
        case 9: try {
          var v: String?
          try decoder.decodeSingularStringField(value: &v)
          if let v = v {
            if _storage._executionIdentity != nil {try decoder.handleConflictingOneOf()}
            _storage._executionIdentity = .executionUser(v)
          }
        }()
        case 10: try { try decoder.decodeSingularEnumField(value: &_storage._jobState) }()
        case 11: try { try decoder.decodeSingularMessageField(value: &_storage._status) }()
        case 12: try { try decoder.decodeSingularMessageField(value: &_storage._createTime) }()
        case 13: try { try decoder.decodeSingularMessageField(value: &_storage._updateTime) }()
        case 14: try {
          var v: String?
          try decoder.decodeSingularStringField(value: &v)
          if let v = v {
            if _storage._environmentSpec != nil {try decoder.handleConflictingOneOf()}
            _storage._environmentSpec = .notebookRuntimeTemplateResourceName(v)
          }
        }()
        case 17: try {
          var v: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource?
          var hadOneofValue = false
          if let current = _storage._notebookSource {
            hadOneofValue = true
            if case .directNotebookSource(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {
            if hadOneofValue {try decoder.handleConflictingOneOf()}
            _storage._notebookSource = .directNotebookSource(v)
          }
        }()
        case 18: try {
          var v: String?
          try decoder.decodeSingularStringField(value: &v)
          if let v = v {
            if _storage._executionIdentity != nil {try decoder.handleConflictingOneOf()}
            _storage._executionIdentity = .serviceAccount(v)
          }
        }()
        case 19: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufString>.self, value: &_storage._labels) }()
        case 22: try { try decoder.decodeSingularMessageField(value: &_storage._encryptionSpec) }()
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      if !_storage._name.isEmpty {
        try visitor.visitSingularStringField(value: _storage._name, fieldNumber: 1)
      }
      if !_storage._displayName.isEmpty {
        try visitor.visitSingularStringField(value: _storage._displayName, fieldNumber: 2)
      }
      switch _storage._notebookSource {
      case .dataformRepositorySource?: try {
        guard case .dataformRepositorySource(let v)? = _storage._notebookSource else { preconditionFailure() }
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      }()
      case .gcsNotebookSource?: try {
        guard case .gcsNotebookSource(let v)? = _storage._notebookSource else { preconditionFailure() }
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      }()
      default: break
      }
      try { if let v = _storage._executionTimeout {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      } }()
      if !_storage._scheduleResourceName.isEmpty {
        try visitor.visitSingularStringField(value: _storage._scheduleResourceName, fieldNumber: 6)
      }
      try { if case .gcsOutputUri(let v)? = _storage._executionSink {
        try visitor.visitSingularStringField(value: v, fieldNumber: 8)
      } }()
      try { if case .executionUser(let v)? = _storage._executionIdentity {
        try visitor.visitSingularStringField(value: v, fieldNumber: 9)
      } }()
      if _storage._jobState != .unspecified {
        try visitor.visitSingularEnumField(value: _storage._jobState, fieldNumber: 10)
      }
      try { if let v = _storage._status {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 11)
      } }()
      try { if let v = _storage._createTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 12)
      } }()
      try { if let v = _storage._updateTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 13)
      } }()
      try { if case .notebookRuntimeTemplateResourceName(let v)? = _storage._environmentSpec {
        try visitor.visitSingularStringField(value: v, fieldNumber: 14)
      } }()
      try { if case .directNotebookSource(let v)? = _storage._notebookSource {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 17)
      } }()
      try { if case .serviceAccount(let v)? = _storage._executionIdentity {
        try visitor.visitSingularStringField(value: v, fieldNumber: 18)
      } }()
      if !_storage._labels.isEmpty {
        try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufString>.self, value: _storage._labels, fieldNumber: 19)
      }
      try { if let v = _storage._encryptionSpec {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 22)
      } }()
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob, rhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._notebookSource != rhs_storage._notebookSource {return false}
        if _storage._environmentSpec != rhs_storage._environmentSpec {return false}
        if _storage._executionSink != rhs_storage._executionSink {return false}
        if _storage._executionIdentity != rhs_storage._executionIdentity {return false}
        if _storage._name != rhs_storage._name {return false}
        if _storage._displayName != rhs_storage._displayName {return false}
        if _storage._executionTimeout != rhs_storage._executionTimeout {return false}
        if _storage._scheduleResourceName != rhs_storage._scheduleResourceName {return false}
        if _storage._jobState != rhs_storage._jobState {return false}
        if _storage._status != rhs_storage._status {return false}
        if _storage._createTime != rhs_storage._createTime {return false}
        if _storage._updateTime != rhs_storage._updateTime {return false}
        if _storage._labels != rhs_storage._labels {return false}
        if _storage._encryptionSpec != rhs_storage._encryptionSpec {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_NotebookExecutionJob.protoMessageName + ".DataformRepositorySource"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "dataform_repository_resource_name"),
    2: .standard(proto: "commit_sha"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.dataformRepositoryResourceName) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.commitSha) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.dataformRepositoryResourceName.isEmpty {
      try visitor.visitSingularStringField(value: self.dataformRepositoryResourceName, fieldNumber: 1)
    }
    if !self.commitSha.isEmpty {
      try visitor.visitSingularStringField(value: self.commitSha, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource, rhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DataformRepositorySource) -> Bool {
    if lhs.dataformRepositoryResourceName != rhs.dataformRepositoryResourceName {return false}
    if lhs.commitSha != rhs.commitSha {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_NotebookExecutionJob.protoMessageName + ".GcsNotebookSource"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "uri"),
    2: .same(proto: "generation"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.generation) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 1)
    }
    if !self.generation.isEmpty {
      try visitor.visitSingularStringField(value: self.generation, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource, rhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.GcsNotebookSource) -> Bool {
    if lhs.uri != rhs.uri {return false}
    if lhs.generation != rhs.generation {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_NotebookExecutionJob.protoMessageName + ".DirectNotebookSource"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "content"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.content) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.content.isEmpty {
      try visitor.visitSingularBytesField(value: self.content, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource, rhs: Google_Cloud_Aiplatform_V1_NotebookExecutionJob.DirectNotebookSource) -> Bool {
    if lhs.content != rhs.content {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
