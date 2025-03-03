// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/hyperparameter_tuning_job.proto
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

/// Represents a HyperparameterTuningJob. A HyperparameterTuningJob
/// has a Study specification and multiple CustomJobs with identical
/// CustomJob specification.
public struct Google_Cloud_Aiplatform_V1_HyperparameterTuningJob: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Output only. Resource name of the HyperparameterTuningJob.
  public var name: String {
    get {return _storage._name}
    set {_uniqueStorage()._name = newValue}
  }

  /// Required. The display name of the HyperparameterTuningJob.
  /// The name can be up to 128 characters long and can consist of any UTF-8
  /// characters.
  public var displayName: String {
    get {return _storage._displayName}
    set {_uniqueStorage()._displayName = newValue}
  }

  /// Required. Study configuration of the HyperparameterTuningJob.
  public var studySpec: Google_Cloud_Aiplatform_V1_StudySpec {
    get {return _storage._studySpec ?? Google_Cloud_Aiplatform_V1_StudySpec()}
    set {_uniqueStorage()._studySpec = newValue}
  }
  /// Returns true if `studySpec` has been explicitly set.
  public var hasStudySpec: Bool {return _storage._studySpec != nil}
  /// Clears the value of `studySpec`. Subsequent reads from it will return its default value.
  public mutating func clearStudySpec() {_uniqueStorage()._studySpec = nil}

  /// Required. The desired total number of Trials.
  public var maxTrialCount: Int32 {
    get {return _storage._maxTrialCount}
    set {_uniqueStorage()._maxTrialCount = newValue}
  }

  /// Required. The desired number of Trials to run in parallel.
  public var parallelTrialCount: Int32 {
    get {return _storage._parallelTrialCount}
    set {_uniqueStorage()._parallelTrialCount = newValue}
  }

  /// The number of failed Trials that need to be seen before failing
  /// the HyperparameterTuningJob.
  ///
  /// If set to 0, Vertex AI decides how many Trials must fail
  /// before the whole job fails.
  public var maxFailedTrialCount: Int32 {
    get {return _storage._maxFailedTrialCount}
    set {_uniqueStorage()._maxFailedTrialCount = newValue}
  }

  /// Required. The spec of a trial job. The same spec applies to the CustomJobs
  /// created in all the trials.
  public var trialJobSpec: Google_Cloud_Aiplatform_V1_CustomJobSpec {
    get {return _storage._trialJobSpec ?? Google_Cloud_Aiplatform_V1_CustomJobSpec()}
    set {_uniqueStorage()._trialJobSpec = newValue}
  }
  /// Returns true if `trialJobSpec` has been explicitly set.
  public var hasTrialJobSpec: Bool {return _storage._trialJobSpec != nil}
  /// Clears the value of `trialJobSpec`. Subsequent reads from it will return its default value.
  public mutating func clearTrialJobSpec() {_uniqueStorage()._trialJobSpec = nil}

  /// Output only. Trials of the HyperparameterTuningJob.
  public var trials: [Google_Cloud_Aiplatform_V1_Trial] {
    get {return _storage._trials}
    set {_uniqueStorage()._trials = newValue}
  }

  /// Output only. The detailed state of the job.
  public var state: Google_Cloud_Aiplatform_V1_JobState {
    get {return _storage._state}
    set {_uniqueStorage()._state = newValue}
  }

  /// Output only. Time when the HyperparameterTuningJob was created.
  public var createTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._createTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._createTime = newValue}
  }
  /// Returns true if `createTime` has been explicitly set.
  public var hasCreateTime: Bool {return _storage._createTime != nil}
  /// Clears the value of `createTime`. Subsequent reads from it will return its default value.
  public mutating func clearCreateTime() {_uniqueStorage()._createTime = nil}

  /// Output only. Time when the HyperparameterTuningJob for the first time
  /// entered the `JOB_STATE_RUNNING` state.
  public var startTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._startTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._startTime = newValue}
  }
  /// Returns true if `startTime` has been explicitly set.
  public var hasStartTime: Bool {return _storage._startTime != nil}
  /// Clears the value of `startTime`. Subsequent reads from it will return its default value.
  public mutating func clearStartTime() {_uniqueStorage()._startTime = nil}

  /// Output only. Time when the HyperparameterTuningJob entered any of the
  /// following states: `JOB_STATE_SUCCEEDED`, `JOB_STATE_FAILED`,
  /// `JOB_STATE_CANCELLED`.
  public var endTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._endTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._endTime = newValue}
  }
  /// Returns true if `endTime` has been explicitly set.
  public var hasEndTime: Bool {return _storage._endTime != nil}
  /// Clears the value of `endTime`. Subsequent reads from it will return its default value.
  public mutating func clearEndTime() {_uniqueStorage()._endTime = nil}

  /// Output only. Time when the HyperparameterTuningJob was most recently
  /// updated.
  public var updateTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._updateTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._updateTime = newValue}
  }
  /// Returns true if `updateTime` has been explicitly set.
  public var hasUpdateTime: Bool {return _storage._updateTime != nil}
  /// Clears the value of `updateTime`. Subsequent reads from it will return its default value.
  public mutating func clearUpdateTime() {_uniqueStorage()._updateTime = nil}

  /// Output only. Only populated when job's state is JOB_STATE_FAILED or
  /// JOB_STATE_CANCELLED.
  public var error: Google_Rpc_Status {
    get {return _storage._error ?? Google_Rpc_Status()}
    set {_uniqueStorage()._error = newValue}
  }
  /// Returns true if `error` has been explicitly set.
  public var hasError: Bool {return _storage._error != nil}
  /// Clears the value of `error`. Subsequent reads from it will return its default value.
  public mutating func clearError() {_uniqueStorage()._error = nil}

  /// The labels with user-defined metadata to organize HyperparameterTuningJobs.
  ///
  /// Label keys and values can be no longer than 64 characters
  /// (Unicode codepoints), can only contain lowercase letters, numeric
  /// characters, underscores and dashes. International characters are allowed.
  ///
  /// See https://goo.gl/xmQnxf for more information and examples of labels.
  public var labels: Dictionary<String,String> {
    get {return _storage._labels}
    set {_uniqueStorage()._labels = newValue}
  }

  /// Customer-managed encryption key options for a HyperparameterTuningJob.
  /// If this is set, then all resources created by the HyperparameterTuningJob
  /// will be encrypted with the provided encryption key.
  public var encryptionSpec: Google_Cloud_Aiplatform_V1_EncryptionSpec {
    get {return _storage._encryptionSpec ?? Google_Cloud_Aiplatform_V1_EncryptionSpec()}
    set {_uniqueStorage()._encryptionSpec = newValue}
  }
  /// Returns true if `encryptionSpec` has been explicitly set.
  public var hasEncryptionSpec: Bool {return _storage._encryptionSpec != nil}
  /// Clears the value of `encryptionSpec`. Subsequent reads from it will return its default value.
  public mutating func clearEncryptionSpec() {_uniqueStorage()._encryptionSpec = nil}

  /// Output only. Reserved for future use.
  public var satisfiesPzs: Bool {
    get {return _storage._satisfiesPzs}
    set {_uniqueStorage()._satisfiesPzs = newValue}
  }

  /// Output only. Reserved for future use.
  public var satisfiesPzi: Bool {
    get {return _storage._satisfiesPzi}
    set {_uniqueStorage()._satisfiesPzi = newValue}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_HyperparameterTuningJob: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".HyperparameterTuningJob"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .standard(proto: "display_name"),
    4: .standard(proto: "study_spec"),
    5: .standard(proto: "max_trial_count"),
    6: .standard(proto: "parallel_trial_count"),
    7: .standard(proto: "max_failed_trial_count"),
    8: .standard(proto: "trial_job_spec"),
    9: .same(proto: "trials"),
    10: .same(proto: "state"),
    11: .standard(proto: "create_time"),
    12: .standard(proto: "start_time"),
    13: .standard(proto: "end_time"),
    14: .standard(proto: "update_time"),
    15: .same(proto: "error"),
    16: .same(proto: "labels"),
    17: .standard(proto: "encryption_spec"),
    19: .standard(proto: "satisfies_pzs"),
    20: .standard(proto: "satisfies_pzi"),
  ]

  fileprivate class _StorageClass {
    var _name: String = String()
    var _displayName: String = String()
    var _studySpec: Google_Cloud_Aiplatform_V1_StudySpec? = nil
    var _maxTrialCount: Int32 = 0
    var _parallelTrialCount: Int32 = 0
    var _maxFailedTrialCount: Int32 = 0
    var _trialJobSpec: Google_Cloud_Aiplatform_V1_CustomJobSpec? = nil
    var _trials: [Google_Cloud_Aiplatform_V1_Trial] = []
    var _state: Google_Cloud_Aiplatform_V1_JobState = .unspecified
    var _createTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _startTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _endTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _updateTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _error: Google_Rpc_Status? = nil
    var _labels: Dictionary<String,String> = [:]
    var _encryptionSpec: Google_Cloud_Aiplatform_V1_EncryptionSpec? = nil
    var _satisfiesPzs: Bool = false
    var _satisfiesPzi: Bool = false

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
      _name = source._name
      _displayName = source._displayName
      _studySpec = source._studySpec
      _maxTrialCount = source._maxTrialCount
      _parallelTrialCount = source._parallelTrialCount
      _maxFailedTrialCount = source._maxFailedTrialCount
      _trialJobSpec = source._trialJobSpec
      _trials = source._trials
      _state = source._state
      _createTime = source._createTime
      _startTime = source._startTime
      _endTime = source._endTime
      _updateTime = source._updateTime
      _error = source._error
      _labels = source._labels
      _encryptionSpec = source._encryptionSpec
      _satisfiesPzs = source._satisfiesPzs
      _satisfiesPzi = source._satisfiesPzi
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
        case 4: try { try decoder.decodeSingularMessageField(value: &_storage._studySpec) }()
        case 5: try { try decoder.decodeSingularInt32Field(value: &_storage._maxTrialCount) }()
        case 6: try { try decoder.decodeSingularInt32Field(value: &_storage._parallelTrialCount) }()
        case 7: try { try decoder.decodeSingularInt32Field(value: &_storage._maxFailedTrialCount) }()
        case 8: try { try decoder.decodeSingularMessageField(value: &_storage._trialJobSpec) }()
        case 9: try { try decoder.decodeRepeatedMessageField(value: &_storage._trials) }()
        case 10: try { try decoder.decodeSingularEnumField(value: &_storage._state) }()
        case 11: try { try decoder.decodeSingularMessageField(value: &_storage._createTime) }()
        case 12: try { try decoder.decodeSingularMessageField(value: &_storage._startTime) }()
        case 13: try { try decoder.decodeSingularMessageField(value: &_storage._endTime) }()
        case 14: try { try decoder.decodeSingularMessageField(value: &_storage._updateTime) }()
        case 15: try { try decoder.decodeSingularMessageField(value: &_storage._error) }()
        case 16: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufString>.self, value: &_storage._labels) }()
        case 17: try { try decoder.decodeSingularMessageField(value: &_storage._encryptionSpec) }()
        case 19: try { try decoder.decodeSingularBoolField(value: &_storage._satisfiesPzs) }()
        case 20: try { try decoder.decodeSingularBoolField(value: &_storage._satisfiesPzi) }()
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
      try { if let v = _storage._studySpec {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      } }()
      if _storage._maxTrialCount != 0 {
        try visitor.visitSingularInt32Field(value: _storage._maxTrialCount, fieldNumber: 5)
      }
      if _storage._parallelTrialCount != 0 {
        try visitor.visitSingularInt32Field(value: _storage._parallelTrialCount, fieldNumber: 6)
      }
      if _storage._maxFailedTrialCount != 0 {
        try visitor.visitSingularInt32Field(value: _storage._maxFailedTrialCount, fieldNumber: 7)
      }
      try { if let v = _storage._trialJobSpec {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
      } }()
      if !_storage._trials.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._trials, fieldNumber: 9)
      }
      if _storage._state != .unspecified {
        try visitor.visitSingularEnumField(value: _storage._state, fieldNumber: 10)
      }
      try { if let v = _storage._createTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 11)
      } }()
      try { if let v = _storage._startTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 12)
      } }()
      try { if let v = _storage._endTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 13)
      } }()
      try { if let v = _storage._updateTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 14)
      } }()
      try { if let v = _storage._error {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 15)
      } }()
      if !_storage._labels.isEmpty {
        try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufString>.self, value: _storage._labels, fieldNumber: 16)
      }
      try { if let v = _storage._encryptionSpec {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 17)
      } }()
      if _storage._satisfiesPzs != false {
        try visitor.visitSingularBoolField(value: _storage._satisfiesPzs, fieldNumber: 19)
      }
      if _storage._satisfiesPzi != false {
        try visitor.visitSingularBoolField(value: _storage._satisfiesPzi, fieldNumber: 20)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_HyperparameterTuningJob, rhs: Google_Cloud_Aiplatform_V1_HyperparameterTuningJob) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._name != rhs_storage._name {return false}
        if _storage._displayName != rhs_storage._displayName {return false}
        if _storage._studySpec != rhs_storage._studySpec {return false}
        if _storage._maxTrialCount != rhs_storage._maxTrialCount {return false}
        if _storage._parallelTrialCount != rhs_storage._parallelTrialCount {return false}
        if _storage._maxFailedTrialCount != rhs_storage._maxFailedTrialCount {return false}
        if _storage._trialJobSpec != rhs_storage._trialJobSpec {return false}
        if _storage._trials != rhs_storage._trials {return false}
        if _storage._state != rhs_storage._state {return false}
        if _storage._createTime != rhs_storage._createTime {return false}
        if _storage._startTime != rhs_storage._startTime {return false}
        if _storage._endTime != rhs_storage._endTime {return false}
        if _storage._updateTime != rhs_storage._updateTime {return false}
        if _storage._error != rhs_storage._error {return false}
        if _storage._labels != rhs_storage._labels {return false}
        if _storage._encryptionSpec != rhs_storage._encryptionSpec {return false}
        if _storage._satisfiesPzs != rhs_storage._satisfiesPzs {return false}
        if _storage._satisfiesPzi != rhs_storage._satisfiesPzi {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
