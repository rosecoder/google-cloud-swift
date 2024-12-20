// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/featurestore_monitoring.proto
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

/// Configuration of how features in Featurestore are monitored.
public struct Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The config for Snapshot Analysis Based Feature Monitoring.
  public var snapshotAnalysis: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.SnapshotAnalysis {
    get {return _snapshotAnalysis ?? Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.SnapshotAnalysis()}
    set {_snapshotAnalysis = newValue}
  }
  /// Returns true if `snapshotAnalysis` has been explicitly set.
  public var hasSnapshotAnalysis: Bool {return self._snapshotAnalysis != nil}
  /// Clears the value of `snapshotAnalysis`. Subsequent reads from it will return its default value.
  public mutating func clearSnapshotAnalysis() {self._snapshotAnalysis = nil}

  /// The config for ImportFeatures Analysis Based Feature Monitoring.
  public var importFeaturesAnalysis: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis {
    get {return _importFeaturesAnalysis ?? Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis()}
    set {_importFeaturesAnalysis = newValue}
  }
  /// Returns true if `importFeaturesAnalysis` has been explicitly set.
  public var hasImportFeaturesAnalysis: Bool {return self._importFeaturesAnalysis != nil}
  /// Clears the value of `importFeaturesAnalysis`. Subsequent reads from it will return its default value.
  public mutating func clearImportFeaturesAnalysis() {self._importFeaturesAnalysis = nil}

  /// Threshold for numerical features of anomaly detection.
  /// This is shared by all objectives of Featurestore Monitoring for numerical
  /// features (i.e. Features with type
  /// ([Feature.ValueType][google.cloud.aiplatform.v1.Feature.ValueType]) DOUBLE
  /// or INT64).
  public var numericalThresholdConfig: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig {
    get {return _numericalThresholdConfig ?? Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig()}
    set {_numericalThresholdConfig = newValue}
  }
  /// Returns true if `numericalThresholdConfig` has been explicitly set.
  public var hasNumericalThresholdConfig: Bool {return self._numericalThresholdConfig != nil}
  /// Clears the value of `numericalThresholdConfig`. Subsequent reads from it will return its default value.
  public mutating func clearNumericalThresholdConfig() {self._numericalThresholdConfig = nil}

  /// Threshold for categorical features of anomaly detection.
  /// This is shared by all types of Featurestore Monitoring for categorical
  /// features (i.e. Features with type
  /// ([Feature.ValueType][google.cloud.aiplatform.v1.Feature.ValueType]) BOOL or
  /// STRING).
  public var categoricalThresholdConfig: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig {
    get {return _categoricalThresholdConfig ?? Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig()}
    set {_categoricalThresholdConfig = newValue}
  }
  /// Returns true if `categoricalThresholdConfig` has been explicitly set.
  public var hasCategoricalThresholdConfig: Bool {return self._categoricalThresholdConfig != nil}
  /// Clears the value of `categoricalThresholdConfig`. Subsequent reads from it will return its default value.
  public mutating func clearCategoricalThresholdConfig() {self._categoricalThresholdConfig = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Configuration of the Featurestore's Snapshot Analysis Based Monitoring.
  /// This type of analysis generates statistics for each Feature based on a
  /// snapshot of the latest feature value of each entities every
  /// monitoring_interval.
  public struct SnapshotAnalysis: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// The monitoring schedule for snapshot analysis.
    /// For EntityType-level config:
    ///   unset / disabled = true indicates disabled by
    ///   default for Features under it; otherwise by default enable snapshot
    ///   analysis monitoring with monitoring_interval for Features under it.
    /// Feature-level config:
    ///   disabled = true indicates disabled regardless of the EntityType-level
    ///   config; unset monitoring_interval indicates going with EntityType-level
    ///   config; otherwise run snapshot analysis monitoring with
    ///   monitoring_interval regardless of the EntityType-level config.
    /// Explicitly Disable the snapshot analysis based monitoring.
    public var disabled: Bool = false

    /// Configuration of the snapshot analysis based monitoring pipeline
    /// running interval. The value indicates number of days.
    public var monitoringIntervalDays: Int32 = 0

    /// Customized export features time window for snapshot analysis. Unit is one
    /// day. Default value is 3 weeks. Minimum value is 1 day. Maximum value is
    /// 4000 days.
    public var stalenessDays: Int32 = 0

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}
  }

  /// Configuration of the Featurestore's ImportFeature Analysis Based
  /// Monitoring. This type of analysis generates statistics for values of each
  /// Feature imported by every
  /// [ImportFeatureValues][google.cloud.aiplatform.v1.FeaturestoreService.ImportFeatureValues]
  /// operation.
  public struct ImportFeaturesAnalysis: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// Whether to enable / disable / inherite default hebavior for import
    /// features analysis.
    public var state: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis.State = .unspecified

    /// The baseline used to do anomaly detection for the statistics generated by
    /// import features analysis.
    public var anomalyDetectionBaseline: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis.Baseline = .unspecified

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    /// The state defines whether to enable ImportFeature analysis.
    public enum State: SwiftProtobuf.Enum, Swift.CaseIterable {
      public typealias RawValue = Int

      /// Should not be used.
      case unspecified // = 0

      /// The default behavior of whether to enable the monitoring.
      /// EntityType-level config: disabled.
      /// Feature-level config: inherited from the configuration of EntityType
      /// this Feature belongs to.
      case `default` // = 1

      /// Explicitly enables import features analysis.
      /// EntityType-level config: by default enables import features analysis
      /// for all Features under it. Feature-level config: enables import
      /// features analysis regardless of the EntityType-level config.
      case enabled // = 2

      /// Explicitly disables import features analysis.
      /// EntityType-level config: by default disables import features analysis
      /// for all Features under it. Feature-level config: disables import
      /// features analysis regardless of the EntityType-level config.
      case disabled // = 3
      case UNRECOGNIZED(Int)

      public init() {
        self = .unspecified
      }

      public init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .unspecified
        case 1: self = .default
        case 2: self = .enabled
        case 3: self = .disabled
        default: self = .UNRECOGNIZED(rawValue)
        }
      }

      public var rawValue: Int {
        switch self {
        case .unspecified: return 0
        case .default: return 1
        case .enabled: return 2
        case .disabled: return 3
        case .UNRECOGNIZED(let i): return i
        }
      }

      // The compiler won't synthesize support with the UNRECOGNIZED case.
      public static let allCases: [Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis.State] = [
        .unspecified,
        .default,
        .enabled,
        .disabled,
      ]

    }

    /// Defines the baseline to do anomaly detection for feature values imported
    /// by each
    /// [ImportFeatureValues][google.cloud.aiplatform.v1.FeaturestoreService.ImportFeatureValues]
    /// operation.
    public enum Baseline: SwiftProtobuf.Enum, Swift.CaseIterable {
      public typealias RawValue = Int

      /// Should not be used.
      case unspecified // = 0

      /// Choose the later one statistics generated by either most recent
      /// snapshot analysis or previous import features analysis. If non of them
      /// exists, skip anomaly detection and only generate a statistics.
      case latestStats // = 1

      /// Use the statistics generated by the most recent snapshot analysis if
      /// exists.
      case mostRecentSnapshotStats // = 2

      /// Use the statistics generated by the previous import features analysis
      /// if exists.
      case previousImportFeaturesStats // = 3
      case UNRECOGNIZED(Int)

      public init() {
        self = .unspecified
      }

      public init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .unspecified
        case 1: self = .latestStats
        case 2: self = .mostRecentSnapshotStats
        case 3: self = .previousImportFeaturesStats
        default: self = .UNRECOGNIZED(rawValue)
        }
      }

      public var rawValue: Int {
        switch self {
        case .unspecified: return 0
        case .latestStats: return 1
        case .mostRecentSnapshotStats: return 2
        case .previousImportFeaturesStats: return 3
        case .UNRECOGNIZED(let i): return i
        }
      }

      // The compiler won't synthesize support with the UNRECOGNIZED case.
      public static let allCases: [Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis.Baseline] = [
        .unspecified,
        .latestStats,
        .mostRecentSnapshotStats,
        .previousImportFeaturesStats,
      ]

    }

    public init() {}
  }

  /// The config for Featurestore Monitoring threshold.
  public struct ThresholdConfig: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    public var threshold: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig.OneOf_Threshold? = nil

    /// Specify a threshold value that can trigger the alert.
    /// 1. For categorical feature, the distribution distance is calculated by
    /// L-inifinity norm.
    /// 2. For numerical feature, the distribution distance is calculated by
    /// Jensen–Shannon divergence. Each feature must have a non-zero threshold
    /// if they need to be monitored. Otherwise no alert will be triggered for
    /// that feature.
    public var value: Double {
      get {
        if case .value(let v)? = threshold {return v}
        return 0
      }
      set {threshold = .value(newValue)}
    }

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public enum OneOf_Threshold: Equatable, Sendable {
      /// Specify a threshold value that can trigger the alert.
      /// 1. For categorical feature, the distribution distance is calculated by
      /// L-inifinity norm.
      /// 2. For numerical feature, the distribution distance is calculated by
      /// Jensen–Shannon divergence. Each feature must have a non-zero threshold
      /// if they need to be monitored. Otherwise no alert will be triggered for
      /// that feature.
      case value(Double)

    }

    public init() {}
  }

  public init() {}

  fileprivate var _snapshotAnalysis: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.SnapshotAnalysis? = nil
  fileprivate var _importFeaturesAnalysis: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis? = nil
  fileprivate var _numericalThresholdConfig: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig? = nil
  fileprivate var _categoricalThresholdConfig: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FeaturestoreMonitoringConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "snapshot_analysis"),
    2: .standard(proto: "import_features_analysis"),
    3: .standard(proto: "numerical_threshold_config"),
    4: .standard(proto: "categorical_threshold_config"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._snapshotAnalysis) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._importFeaturesAnalysis) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._numericalThresholdConfig) }()
      case 4: try { try decoder.decodeSingularMessageField(value: &self._categoricalThresholdConfig) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._snapshotAnalysis {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._importFeaturesAnalysis {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try { if let v = self._numericalThresholdConfig {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    try { if let v = self._categoricalThresholdConfig {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig, rhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig) -> Bool {
    if lhs._snapshotAnalysis != rhs._snapshotAnalysis {return false}
    if lhs._importFeaturesAnalysis != rhs._importFeaturesAnalysis {return false}
    if lhs._numericalThresholdConfig != rhs._numericalThresholdConfig {return false}
    if lhs._categoricalThresholdConfig != rhs._categoricalThresholdConfig {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.SnapshotAnalysis: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.protoMessageName + ".SnapshotAnalysis"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "disabled"),
    3: .standard(proto: "monitoring_interval_days"),
    4: .standard(proto: "staleness_days"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBoolField(value: &self.disabled) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.monitoringIntervalDays) }()
      case 4: try { try decoder.decodeSingularInt32Field(value: &self.stalenessDays) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.disabled != false {
      try visitor.visitSingularBoolField(value: self.disabled, fieldNumber: 1)
    }
    if self.monitoringIntervalDays != 0 {
      try visitor.visitSingularInt32Field(value: self.monitoringIntervalDays, fieldNumber: 3)
    }
    if self.stalenessDays != 0 {
      try visitor.visitSingularInt32Field(value: self.stalenessDays, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.SnapshotAnalysis, rhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.SnapshotAnalysis) -> Bool {
    if lhs.disabled != rhs.disabled {return false}
    if lhs.monitoringIntervalDays != rhs.monitoringIntervalDays {return false}
    if lhs.stalenessDays != rhs.stalenessDays {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.protoMessageName + ".ImportFeaturesAnalysis"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "state"),
    2: .standard(proto: "anomaly_detection_baseline"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.state) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.anomalyDetectionBaseline) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.state != .unspecified {
      try visitor.visitSingularEnumField(value: self.state, fieldNumber: 1)
    }
    if self.anomalyDetectionBaseline != .unspecified {
      try visitor.visitSingularEnumField(value: self.anomalyDetectionBaseline, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis, rhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis) -> Bool {
    if lhs.state != rhs.state {return false}
    if lhs.anomalyDetectionBaseline != rhs.anomalyDetectionBaseline {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis.State: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "STATE_UNSPECIFIED"),
    1: .same(proto: "DEFAULT"),
    2: .same(proto: "ENABLED"),
    3: .same(proto: "DISABLED"),
  ]
}

extension Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ImportFeaturesAnalysis.Baseline: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "BASELINE_UNSPECIFIED"),
    1: .same(proto: "LATEST_STATS"),
    2: .same(proto: "MOST_RECENT_SNAPSHOT_STATS"),
    3: .same(proto: "PREVIOUS_IMPORT_FEATURES_STATS"),
  ]
}

extension Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.protoMessageName + ".ThresholdConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try {
        var v: Double?
        try decoder.decodeSingularDoubleField(value: &v)
        if let v = v {
          if self.threshold != nil {try decoder.handleConflictingOneOf()}
          self.threshold = .value(v)
        }
      }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if case .value(let v)? = self.threshold {
      try visitor.visitSingularDoubleField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig, rhs: Google_Cloud_Aiplatform_V1_FeaturestoreMonitoringConfig.ThresholdConfig) -> Bool {
    if lhs.threshold != rhs.threshold {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
