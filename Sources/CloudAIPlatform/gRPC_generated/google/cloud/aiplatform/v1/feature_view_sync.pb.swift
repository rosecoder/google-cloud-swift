// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/feature_view_sync.proto
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

/// FeatureViewSync is a representation of sync operation which copies data from
/// data source to Feature View in Online Store.
public struct Google_Cloud_Aiplatform_V1_FeatureViewSync: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Identifier. Name of the FeatureViewSync. Format:
  /// `projects/{project}/locations/{location}/featureOnlineStores/{feature_online_store}/featureViews/{feature_view}/featureViewSyncs/{feature_view_sync}`
  public var name: String = String()

  /// Output only. Time when this FeatureViewSync is created. Creation of a
  /// FeatureViewSync means that the job is pending / waiting for sufficient
  /// resources but may not have started the actual data transfer yet.
  public var createTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _createTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_createTime = newValue}
  }
  /// Returns true if `createTime` has been explicitly set.
  public var hasCreateTime: Bool {return self._createTime != nil}
  /// Clears the value of `createTime`. Subsequent reads from it will return its default value.
  public mutating func clearCreateTime() {self._createTime = nil}

  /// Output only. Time when this FeatureViewSync is finished.
  public var runTime: Google_Type_Interval {
    get {return _runTime ?? Google_Type_Interval()}
    set {_runTime = newValue}
  }
  /// Returns true if `runTime` has been explicitly set.
  public var hasRunTime: Bool {return self._runTime != nil}
  /// Clears the value of `runTime`. Subsequent reads from it will return its default value.
  public mutating func clearRunTime() {self._runTime = nil}

  /// Output only. Final status of the FeatureViewSync.
  public var finalStatus: Google_Rpc_Status {
    get {return _finalStatus ?? Google_Rpc_Status()}
    set {_finalStatus = newValue}
  }
  /// Returns true if `finalStatus` has been explicitly set.
  public var hasFinalStatus: Bool {return self._finalStatus != nil}
  /// Clears the value of `finalStatus`. Subsequent reads from it will return its default value.
  public mutating func clearFinalStatus() {self._finalStatus = nil}

  /// Output only. Summary of the sync job.
  public var syncSummary: Google_Cloud_Aiplatform_V1_FeatureViewSync.SyncSummary {
    get {return _syncSummary ?? Google_Cloud_Aiplatform_V1_FeatureViewSync.SyncSummary()}
    set {_syncSummary = newValue}
  }
  /// Returns true if `syncSummary` has been explicitly set.
  public var hasSyncSummary: Bool {return self._syncSummary != nil}
  /// Clears the value of `syncSummary`. Subsequent reads from it will return its default value.
  public mutating func clearSyncSummary() {self._syncSummary = nil}

  /// Output only. Reserved for future use.
  public var satisfiesPzs: Bool = false

  /// Output only. Reserved for future use.
  public var satisfiesPzi: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Summary from the Sync job. For continuous syncs, the summary is updated
  /// periodically. For batch syncs, it gets updated on completion of the sync.
  public struct SyncSummary: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// Output only. Total number of rows synced.
    public var rowSynced: Int64 = 0

    /// Output only. BigQuery slot milliseconds consumed for the sync job.
    public var totalSlot: Int64 = 0

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}
  }

  public init() {}

  fileprivate var _createTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
  fileprivate var _runTime: Google_Type_Interval? = nil
  fileprivate var _finalStatus: Google_Rpc_Status? = nil
  fileprivate var _syncSummary: Google_Cloud_Aiplatform_V1_FeatureViewSync.SyncSummary? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_FeatureViewSync: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FeatureViewSync"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .standard(proto: "create_time"),
    5: .standard(proto: "run_time"),
    4: .standard(proto: "final_status"),
    6: .standard(proto: "sync_summary"),
    7: .standard(proto: "satisfies_pzs"),
    8: .standard(proto: "satisfies_pzi"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._createTime) }()
      case 4: try { try decoder.decodeSingularMessageField(value: &self._finalStatus) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._runTime) }()
      case 6: try { try decoder.decodeSingularMessageField(value: &self._syncSummary) }()
      case 7: try { try decoder.decodeSingularBoolField(value: &self.satisfiesPzs) }()
      case 8: try { try decoder.decodeSingularBoolField(value: &self.satisfiesPzi) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    try { if let v = self._createTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try { if let v = self._finalStatus {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    } }()
    try { if let v = self._runTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try { if let v = self._syncSummary {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    } }()
    if self.satisfiesPzs != false {
      try visitor.visitSingularBoolField(value: self.satisfiesPzs, fieldNumber: 7)
    }
    if self.satisfiesPzi != false {
      try visitor.visitSingularBoolField(value: self.satisfiesPzi, fieldNumber: 8)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeatureViewSync, rhs: Google_Cloud_Aiplatform_V1_FeatureViewSync) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs._createTime != rhs._createTime {return false}
    if lhs._runTime != rhs._runTime {return false}
    if lhs._finalStatus != rhs._finalStatus {return false}
    if lhs._syncSummary != rhs._syncSummary {return false}
    if lhs.satisfiesPzs != rhs.satisfiesPzs {return false}
    if lhs.satisfiesPzi != rhs.satisfiesPzi {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FeatureViewSync.SyncSummary: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_FeatureViewSync.protoMessageName + ".SyncSummary"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "row_synced"),
    2: .standard(proto: "total_slot"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt64Field(value: &self.rowSynced) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.totalSlot) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.rowSynced != 0 {
      try visitor.visitSingularInt64Field(value: self.rowSynced, fieldNumber: 1)
    }
    if self.totalSlot != 0 {
      try visitor.visitSingularInt64Field(value: self.totalSlot, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeatureViewSync.SyncSummary, rhs: Google_Cloud_Aiplatform_V1_FeatureViewSync.SyncSummary) -> Bool {
    if lhs.rowSynced != rhs.rowSynced {return false}
    if lhs.totalSlot != rhs.totalSlot {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}