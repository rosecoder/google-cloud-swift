// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/feature_monitoring_stats.proto
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

/// Stats and Anomaly generated at specific timestamp for specific Feature.
/// The start_time and end_time are used to define the time range of the dataset
/// that current stats belongs to, e.g. prediction traffic is bucketed into
/// prediction datasets by time window. If the Dataset is not defined by time
/// window, start_time = end_time. Timestamp of the stats and anomalies always
/// refers to end_time. Raw stats and anomalies are stored in stats_uri or
/// anomaly_uri in the tensorflow defined protos. Field data_stats contains
/// almost identical information with the raw stats in Vertex AI
/// defined proto, for UI to display.
public struct Google_Cloud_Aiplatform_V1_FeatureStatsAnomaly: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Feature importance score, only populated when cross-feature monitoring is
  /// enabled. For now only used to represent feature attribution score within
  /// range [0, 1] for
  /// [ModelDeploymentMonitoringObjectiveType.FEATURE_ATTRIBUTION_SKEW][google.cloud.aiplatform.v1.ModelDeploymentMonitoringObjectiveType.FEATURE_ATTRIBUTION_SKEW]
  /// and
  /// [ModelDeploymentMonitoringObjectiveType.FEATURE_ATTRIBUTION_DRIFT][google.cloud.aiplatform.v1.ModelDeploymentMonitoringObjectiveType.FEATURE_ATTRIBUTION_DRIFT].
  public var score: Double = 0

  /// Path of the stats file for current feature values in Cloud Storage bucket.
  /// Format: gs://<bucket_name>/<object_name>/stats.
  /// Example: gs://monitoring_bucket/feature_name/stats.
  /// Stats are stored as binary format with Protobuf message
  /// [tensorflow.metadata.v0.FeatureNameStatistics](https://github.com/tensorflow/metadata/blob/master/tensorflow_metadata/proto/v0/statistics.proto).
  public var statsUri: String = String()

  /// Path of the anomaly file for current feature values in Cloud Storage
  /// bucket.
  /// Format: gs://<bucket_name>/<object_name>/anomalies.
  /// Example: gs://monitoring_bucket/feature_name/anomalies.
  /// Stats are stored as binary format with Protobuf message
  /// Anoamlies are stored as binary format with Protobuf message
  /// [tensorflow.metadata.v0.AnomalyInfo]
  /// (https://github.com/tensorflow/metadata/blob/master/tensorflow_metadata/proto/v0/anomalies.proto).
  public var anomalyUri: String = String()

  /// Deviation from the current stats to baseline stats.
  ///   1. For categorical feature, the distribution distance is calculated by
  ///      L-inifinity norm.
  ///   2. For numerical feature, the distribution distance is calculated by
  ///      Jensen–Shannon divergence.
  public var distributionDeviation: Double = 0

  /// This is the threshold used when detecting anomalies.
  /// The threshold can be changed by user, so this one might be different from
  /// [ThresholdConfig.value][google.cloud.aiplatform.v1.ThresholdConfig.value].
  public var anomalyDetectionThreshold: Double = 0

  /// The start timestamp of window where stats were generated.
  /// For objectives where time window doesn't make sense (e.g. Featurestore
  /// Snapshot Monitoring), start_time is only used to indicate the monitoring
  /// intervals, so it always equals to (end_time - monitoring_interval).
  public var startTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _startTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_startTime = newValue}
  }
  /// Returns true if `startTime` has been explicitly set.
  public var hasStartTime: Bool {return self._startTime != nil}
  /// Clears the value of `startTime`. Subsequent reads from it will return its default value.
  public mutating func clearStartTime() {self._startTime = nil}

  /// The end timestamp of window where stats were generated.
  /// For objectives where time window doesn't make sense (e.g. Featurestore
  /// Snapshot Monitoring), end_time indicates the timestamp of the data used to
  /// generate stats (e.g. timestamp we take snapshots for feature values).
  public var endTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _endTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_endTime = newValue}
  }
  /// Returns true if `endTime` has been explicitly set.
  public var hasEndTime: Bool {return self._endTime != nil}
  /// Clears the value of `endTime`. Subsequent reads from it will return its default value.
  public mutating func clearEndTime() {self._endTime = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _startTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
  fileprivate var _endTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_FeatureStatsAnomaly: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FeatureStatsAnomaly"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "score"),
    3: .standard(proto: "stats_uri"),
    4: .standard(proto: "anomaly_uri"),
    5: .standard(proto: "distribution_deviation"),
    9: .standard(proto: "anomaly_detection_threshold"),
    7: .standard(proto: "start_time"),
    8: .standard(proto: "end_time"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularDoubleField(value: &self.score) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.statsUri) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.anomalyUri) }()
      case 5: try { try decoder.decodeSingularDoubleField(value: &self.distributionDeviation) }()
      case 7: try { try decoder.decodeSingularMessageField(value: &self._startTime) }()
      case 8: try { try decoder.decodeSingularMessageField(value: &self._endTime) }()
      case 9: try { try decoder.decodeSingularDoubleField(value: &self.anomalyDetectionThreshold) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.score.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.score, fieldNumber: 1)
    }
    if !self.statsUri.isEmpty {
      try visitor.visitSingularStringField(value: self.statsUri, fieldNumber: 3)
    }
    if !self.anomalyUri.isEmpty {
      try visitor.visitSingularStringField(value: self.anomalyUri, fieldNumber: 4)
    }
    if self.distributionDeviation.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.distributionDeviation, fieldNumber: 5)
    }
    try { if let v = self._startTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
    } }()
    try { if let v = self._endTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
    } }()
    if self.anomalyDetectionThreshold.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.anomalyDetectionThreshold, fieldNumber: 9)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeatureStatsAnomaly, rhs: Google_Cloud_Aiplatform_V1_FeatureStatsAnomaly) -> Bool {
    if lhs.score != rhs.score {return false}
    if lhs.statsUri != rhs.statsUri {return false}
    if lhs.anomalyUri != rhs.anomalyUri {return false}
    if lhs.distributionDeviation != rhs.distributionDeviation {return false}
    if lhs.anomalyDetectionThreshold != rhs.anomalyDetectionThreshold {return false}
    if lhs._startTime != rhs._startTime {return false}
    if lhs._endTime != rhs._endTime {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}