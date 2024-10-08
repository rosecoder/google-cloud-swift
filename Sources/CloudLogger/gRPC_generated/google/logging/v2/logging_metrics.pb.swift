// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/logging/v2/logging_metrics.proto
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

/// Describes a logs-based metric. The value of the metric is the number of log
/// entries that match a logs filter in a given time interval.
///
/// Logs-based metrics can also be used to extract values from logs and create a
/// distribution of the values. The distribution records the statistics of the
/// extracted values along with an optional histogram of the values as specified
/// by the bucket options.
struct Google_Logging_V2_LogMetric: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The client-assigned metric identifier.
  /// Examples: `"error_count"`, `"nginx/requests"`.
  ///
  /// Metric identifiers are limited to 100 characters and can include only the
  /// following characters: `A-Z`, `a-z`, `0-9`, and the special characters
  /// `_-.,+!*',()%/`. The forward-slash character (`/`) denotes a hierarchy of
  /// name pieces, and it cannot be the first character of the name.
  ///
  /// This field is the `[METRIC_ID]` part of a metric resource name in the
  /// format "projects/[PROJECT_ID]/metrics/[METRIC_ID]". Example: If the
  /// resource name of a metric is
  /// `"projects/my-project/metrics/nginx%2Frequests"`, this field's value is
  /// `"nginx/requests"`.
  var name: String {
    get {return _storage._name}
    set {_uniqueStorage()._name = newValue}
  }

  /// Optional. A description of this metric, which is used in documentation.
  /// The maximum length of the description is 8000 characters.
  var description_p: String {
    get {return _storage._description_p}
    set {_uniqueStorage()._description_p = newValue}
  }

  /// Required. An [advanced logs
  /// filter](https://cloud.google.com/logging/docs/view/advanced_filters) which
  /// is used to match log entries. Example:
  ///
  ///     "resource.type=gae_app AND severity>=ERROR"
  ///
  /// The maximum length of the filter is 20000 characters.
  var filter: String {
    get {return _storage._filter}
    set {_uniqueStorage()._filter = newValue}
  }

  /// Optional. The resource name of the Log Bucket that owns the Log Metric.
  /// Only Log Buckets in projects are supported. The bucket has to be in the
  /// same project as the metric.
  ///
  /// For example:
  ///
  ///   `projects/my-project/locations/global/buckets/my-bucket`
  ///
  /// If empty, then the Log Metric is considered a non-Bucket Log Metric.
  var bucketName: String {
    get {return _storage._bucketName}
    set {_uniqueStorage()._bucketName = newValue}
  }

  /// Optional. If set to True, then this metric is disabled and it does not
  /// generate any points.
  var disabled: Bool {
    get {return _storage._disabled}
    set {_uniqueStorage()._disabled = newValue}
  }

  /// Optional. The metric descriptor associated with the logs-based metric.
  /// If unspecified, it uses a default metric descriptor with a DELTA metric
  /// kind, INT64 value type, with no labels and a unit of "1". Such a metric
  /// counts the number of log entries matching the `filter` expression.
  ///
  /// The `name`, `type`, and `description` fields in the `metric_descriptor`
  /// are output only, and is constructed using the `name` and `description`
  /// field in the LogMetric.
  ///
  /// To create a logs-based metric that records a distribution of log values, a
  /// DELTA metric kind with a DISTRIBUTION value type must be used along with
  /// a `value_extractor` expression in the LogMetric.
  ///
  /// Each label in the metric descriptor must have a matching label
  /// name as the key and an extractor expression as the value in the
  /// `label_extractors` map.
  ///
  /// The `metric_kind` and `value_type` fields in the `metric_descriptor` cannot
  /// be updated once initially configured. New labels can be added in the
  /// `metric_descriptor`, but existing labels cannot be modified except for
  /// their description.
  var metricDescriptor: Google_Api_MetricDescriptor {
    get {return _storage._metricDescriptor ?? Google_Api_MetricDescriptor()}
    set {_uniqueStorage()._metricDescriptor = newValue}
  }
  /// Returns true if `metricDescriptor` has been explicitly set.
  var hasMetricDescriptor: Bool {return _storage._metricDescriptor != nil}
  /// Clears the value of `metricDescriptor`. Subsequent reads from it will return its default value.
  mutating func clearMetricDescriptor() {_uniqueStorage()._metricDescriptor = nil}

  /// Optional. A `value_extractor` is required when using a distribution
  /// logs-based metric to extract the values to record from a log entry.
  /// Two functions are supported for value extraction: `EXTRACT(field)` or
  /// `REGEXP_EXTRACT(field, regex)`. The arguments are:
  ///
  ///   1. field: The name of the log entry field from which the value is to be
  ///      extracted.
  ///   2. regex: A regular expression using the Google RE2 syntax
  ///      (https://github.com/google/re2/wiki/Syntax) with a single capture
  ///      group to extract data from the specified log entry field. The value
  ///      of the field is converted to a string before applying the regex.
  ///      It is an error to specify a regex that does not include exactly one
  ///      capture group.
  ///
  /// The result of the extraction must be convertible to a double type, as the
  /// distribution always records double values. If either the extraction or
  /// the conversion to double fails, then those values are not recorded in the
  /// distribution.
  ///
  /// Example: `REGEXP_EXTRACT(jsonPayload.request, ".*quantity=(\d+).*")`
  var valueExtractor: String {
    get {return _storage._valueExtractor}
    set {_uniqueStorage()._valueExtractor = newValue}
  }

  /// Optional. A map from a label key string to an extractor expression which is
  /// used to extract data from a log entry field and assign as the label value.
  /// Each label key specified in the LabelDescriptor must have an associated
  /// extractor expression in this map. The syntax of the extractor expression
  /// is the same as for the `value_extractor` field.
  ///
  /// The extracted value is converted to the type defined in the label
  /// descriptor. If either the extraction or the type conversion fails,
  /// the label will have a default value. The default value for a string
  /// label is an empty string, for an integer label its 0, and for a boolean
  /// label its `false`.
  ///
  /// Note that there are upper bounds on the maximum number of labels and the
  /// number of active time series that are allowed in a project.
  var labelExtractors: Dictionary<String,String> {
    get {return _storage._labelExtractors}
    set {_uniqueStorage()._labelExtractors = newValue}
  }

  /// Optional. The `bucket_options` are required when the logs-based metric is
  /// using a DISTRIBUTION value type and it describes the bucket boundaries
  /// used to create a histogram of the extracted values.
  var bucketOptions: Google_Api_Distribution.BucketOptions {
    get {return _storage._bucketOptions ?? Google_Api_Distribution.BucketOptions()}
    set {_uniqueStorage()._bucketOptions = newValue}
  }
  /// Returns true if `bucketOptions` has been explicitly set.
  var hasBucketOptions: Bool {return _storage._bucketOptions != nil}
  /// Clears the value of `bucketOptions`. Subsequent reads from it will return its default value.
  mutating func clearBucketOptions() {_uniqueStorage()._bucketOptions = nil}

  /// Output only. The creation timestamp of the metric.
  ///
  /// This field may not be present for older metrics.
  var createTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._createTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._createTime = newValue}
  }
  /// Returns true if `createTime` has been explicitly set.
  var hasCreateTime: Bool {return _storage._createTime != nil}
  /// Clears the value of `createTime`. Subsequent reads from it will return its default value.
  mutating func clearCreateTime() {_uniqueStorage()._createTime = nil}

  /// Output only. The last update timestamp of the metric.
  ///
  /// This field may not be present for older metrics.
  var updateTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _storage._updateTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_uniqueStorage()._updateTime = newValue}
  }
  /// Returns true if `updateTime` has been explicitly set.
  var hasUpdateTime: Bool {return _storage._updateTime != nil}
  /// Clears the value of `updateTime`. Subsequent reads from it will return its default value.
  mutating func clearUpdateTime() {_uniqueStorage()._updateTime = nil}

  /// Deprecated. The API version that created or updated this metric.
  /// The v2 format is used by default and cannot be changed.
  ///
  /// NOTE: This field was marked as deprecated in the .proto file.
  var version: Google_Logging_V2_LogMetric.ApiVersion {
    get {return _storage._version}
    set {_uniqueStorage()._version = newValue}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Logging API version.
  enum ApiVersion: SwiftProtobuf.Enum, Swift.CaseIterable {
    typealias RawValue = Int

    /// Logging API v2.
    case v2 // = 0

    /// Logging API v1.
    case v1 // = 1
    case UNRECOGNIZED(Int)

    init() {
      self = .v2
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .v2
      case 1: self = .v1
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .v2: return 0
      case .v1: return 1
      case .UNRECOGNIZED(let i): return i
      }
    }

    // The compiler won't synthesize support with the UNRECOGNIZED case.
    static let allCases: [Google_Logging_V2_LogMetric.ApiVersion] = [
      .v2,
      .v1,
    ]

  }

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

/// The parameters to ListLogMetrics.
struct Google_Logging_V2_ListLogMetricsRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The name of the project containing the metrics:
  ///
  ///     "projects/[PROJECT_ID]"
  var parent: String = String()

  /// Optional. If present, then retrieve the next batch of results from the
  /// preceding call to this method. `pageToken` must be the value of
  /// `nextPageToken` from the previous response. The values of other method
  /// parameters should be identical to those in the previous call.
  var pageToken: String = String()

  /// Optional. The maximum number of results to return from this request.
  /// Non-positive values are ignored. The presence of `nextPageToken` in the
  /// response indicates that more results might be available.
  var pageSize: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Result returned from ListLogMetrics.
struct Google_Logging_V2_ListLogMetricsResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// A list of logs-based metrics.
  var metrics: [Google_Logging_V2_LogMetric] = []

  /// If there might be more results than appear in this response, then
  /// `nextPageToken` is included. To get the next set of results, call this
  /// method again using the value of `nextPageToken` as `pageToken`.
  var nextPageToken: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// The parameters to GetLogMetric.
struct Google_Logging_V2_GetLogMetricRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The resource name of the desired metric:
  ///
  ///     "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  var metricName: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// The parameters to CreateLogMetric.
struct Google_Logging_V2_CreateLogMetricRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The resource name of the project in which to create the metric:
  ///
  ///     "projects/[PROJECT_ID]"
  ///
  /// The new metric must be provided in the request.
  var parent: String = String()

  /// Required. The new logs-based metric, which must not have an identifier that
  /// already exists.
  var metric: Google_Logging_V2_LogMetric {
    get {return _metric ?? Google_Logging_V2_LogMetric()}
    set {_metric = newValue}
  }
  /// Returns true if `metric` has been explicitly set.
  var hasMetric: Bool {return self._metric != nil}
  /// Clears the value of `metric`. Subsequent reads from it will return its default value.
  mutating func clearMetric() {self._metric = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _metric: Google_Logging_V2_LogMetric? = nil
}

/// The parameters to UpdateLogMetric.
struct Google_Logging_V2_UpdateLogMetricRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The resource name of the metric to update:
  ///
  ///     "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  ///
  /// The updated metric must be provided in the request and it's
  /// `name` field must be the same as `[METRIC_ID]` If the metric
  /// does not exist in `[PROJECT_ID]`, then a new metric is created.
  var metricName: String = String()

  /// Required. The updated metric.
  var metric: Google_Logging_V2_LogMetric {
    get {return _metric ?? Google_Logging_V2_LogMetric()}
    set {_metric = newValue}
  }
  /// Returns true if `metric` has been explicitly set.
  var hasMetric: Bool {return self._metric != nil}
  /// Clears the value of `metric`. Subsequent reads from it will return its default value.
  mutating func clearMetric() {self._metric = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _metric: Google_Logging_V2_LogMetric? = nil
}

/// The parameters to DeleteLogMetric.
struct Google_Logging_V2_DeleteLogMetricRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The resource name of the metric to delete:
  ///
  ///     "projects/[PROJECT_ID]/metrics/[METRIC_ID]"
  var metricName: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.logging.v2"

extension Google_Logging_V2_LogMetric: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".LogMetric"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "description"),
    3: .same(proto: "filter"),
    13: .standard(proto: "bucket_name"),
    12: .same(proto: "disabled"),
    5: .standard(proto: "metric_descriptor"),
    6: .standard(proto: "value_extractor"),
    7: .standard(proto: "label_extractors"),
    8: .standard(proto: "bucket_options"),
    9: .standard(proto: "create_time"),
    10: .standard(proto: "update_time"),
    4: .same(proto: "version"),
  ]

  fileprivate class _StorageClass {
    var _name: String = String()
    var _description_p: String = String()
    var _filter: String = String()
    var _bucketName: String = String()
    var _disabled: Bool = false
    var _metricDescriptor: Google_Api_MetricDescriptor? = nil
    var _valueExtractor: String = String()
    var _labelExtractors: Dictionary<String,String> = [:]
    var _bucketOptions: Google_Api_Distribution.BucketOptions? = nil
    var _createTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _updateTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
    var _version: Google_Logging_V2_LogMetric.ApiVersion = .v2

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
      _description_p = source._description_p
      _filter = source._filter
      _bucketName = source._bucketName
      _disabled = source._disabled
      _metricDescriptor = source._metricDescriptor
      _valueExtractor = source._valueExtractor
      _labelExtractors = source._labelExtractors
      _bucketOptions = source._bucketOptions
      _createTime = source._createTime
      _updateTime = source._updateTime
      _version = source._version
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularStringField(value: &_storage._name) }()
        case 2: try { try decoder.decodeSingularStringField(value: &_storage._description_p) }()
        case 3: try { try decoder.decodeSingularStringField(value: &_storage._filter) }()
        case 4: try { try decoder.decodeSingularEnumField(value: &_storage._version) }()
        case 5: try { try decoder.decodeSingularMessageField(value: &_storage._metricDescriptor) }()
        case 6: try { try decoder.decodeSingularStringField(value: &_storage._valueExtractor) }()
        case 7: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufString>.self, value: &_storage._labelExtractors) }()
        case 8: try { try decoder.decodeSingularMessageField(value: &_storage._bucketOptions) }()
        case 9: try { try decoder.decodeSingularMessageField(value: &_storage._createTime) }()
        case 10: try { try decoder.decodeSingularMessageField(value: &_storage._updateTime) }()
        case 12: try { try decoder.decodeSingularBoolField(value: &_storage._disabled) }()
        case 13: try { try decoder.decodeSingularStringField(value: &_storage._bucketName) }()
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      if !_storage._name.isEmpty {
        try visitor.visitSingularStringField(value: _storage._name, fieldNumber: 1)
      }
      if !_storage._description_p.isEmpty {
        try visitor.visitSingularStringField(value: _storage._description_p, fieldNumber: 2)
      }
      if !_storage._filter.isEmpty {
        try visitor.visitSingularStringField(value: _storage._filter, fieldNumber: 3)
      }
      if _storage._version != .v2 {
        try visitor.visitSingularEnumField(value: _storage._version, fieldNumber: 4)
      }
      try { if let v = _storage._metricDescriptor {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      } }()
      if !_storage._valueExtractor.isEmpty {
        try visitor.visitSingularStringField(value: _storage._valueExtractor, fieldNumber: 6)
      }
      if !_storage._labelExtractors.isEmpty {
        try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString,SwiftProtobuf.ProtobufString>.self, value: _storage._labelExtractors, fieldNumber: 7)
      }
      try { if let v = _storage._bucketOptions {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
      } }()
      try { if let v = _storage._createTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 9)
      } }()
      try { if let v = _storage._updateTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
      } }()
      if _storage._disabled != false {
        try visitor.visitSingularBoolField(value: _storage._disabled, fieldNumber: 12)
      }
      if !_storage._bucketName.isEmpty {
        try visitor.visitSingularStringField(value: _storage._bucketName, fieldNumber: 13)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_LogMetric, rhs: Google_Logging_V2_LogMetric) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._name != rhs_storage._name {return false}
        if _storage._description_p != rhs_storage._description_p {return false}
        if _storage._filter != rhs_storage._filter {return false}
        if _storage._bucketName != rhs_storage._bucketName {return false}
        if _storage._disabled != rhs_storage._disabled {return false}
        if _storage._metricDescriptor != rhs_storage._metricDescriptor {return false}
        if _storage._valueExtractor != rhs_storage._valueExtractor {return false}
        if _storage._labelExtractors != rhs_storage._labelExtractors {return false}
        if _storage._bucketOptions != rhs_storage._bucketOptions {return false}
        if _storage._createTime != rhs_storage._createTime {return false}
        if _storage._updateTime != rhs_storage._updateTime {return false}
        if _storage._version != rhs_storage._version {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Logging_V2_LogMetric.ApiVersion: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "V2"),
    1: .same(proto: "V1"),
  ]
}

extension Google_Logging_V2_ListLogMetricsRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ListLogMetricsRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "parent"),
    2: .standard(proto: "page_token"),
    3: .standard(proto: "page_size"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.parent) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.pageToken) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.pageSize) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.parent.isEmpty {
      try visitor.visitSingularStringField(value: self.parent, fieldNumber: 1)
    }
    if !self.pageToken.isEmpty {
      try visitor.visitSingularStringField(value: self.pageToken, fieldNumber: 2)
    }
    if self.pageSize != 0 {
      try visitor.visitSingularInt32Field(value: self.pageSize, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_ListLogMetricsRequest, rhs: Google_Logging_V2_ListLogMetricsRequest) -> Bool {
    if lhs.parent != rhs.parent {return false}
    if lhs.pageToken != rhs.pageToken {return false}
    if lhs.pageSize != rhs.pageSize {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Logging_V2_ListLogMetricsResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ListLogMetricsResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "metrics"),
    2: .standard(proto: "next_page_token"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.metrics) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.nextPageToken) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.metrics.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.metrics, fieldNumber: 1)
    }
    if !self.nextPageToken.isEmpty {
      try visitor.visitSingularStringField(value: self.nextPageToken, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_ListLogMetricsResponse, rhs: Google_Logging_V2_ListLogMetricsResponse) -> Bool {
    if lhs.metrics != rhs.metrics {return false}
    if lhs.nextPageToken != rhs.nextPageToken {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Logging_V2_GetLogMetricRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".GetLogMetricRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "metric_name"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.metricName) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.metricName.isEmpty {
      try visitor.visitSingularStringField(value: self.metricName, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_GetLogMetricRequest, rhs: Google_Logging_V2_GetLogMetricRequest) -> Bool {
    if lhs.metricName != rhs.metricName {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Logging_V2_CreateLogMetricRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CreateLogMetricRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "parent"),
    2: .same(proto: "metric"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.parent) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._metric) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.parent.isEmpty {
      try visitor.visitSingularStringField(value: self.parent, fieldNumber: 1)
    }
    try { if let v = self._metric {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_CreateLogMetricRequest, rhs: Google_Logging_V2_CreateLogMetricRequest) -> Bool {
    if lhs.parent != rhs.parent {return false}
    if lhs._metric != rhs._metric {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Logging_V2_UpdateLogMetricRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".UpdateLogMetricRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "metric_name"),
    2: .same(proto: "metric"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.metricName) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._metric) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.metricName.isEmpty {
      try visitor.visitSingularStringField(value: self.metricName, fieldNumber: 1)
    }
    try { if let v = self._metric {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_UpdateLogMetricRequest, rhs: Google_Logging_V2_UpdateLogMetricRequest) -> Bool {
    if lhs.metricName != rhs.metricName {return false}
    if lhs._metric != rhs._metric {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Logging_V2_DeleteLogMetricRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".DeleteLogMetricRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "metric_name"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.metricName) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.metricName.isEmpty {
      try visitor.visitSingularStringField(value: self.metricName, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Google_Logging_V2_DeleteLogMetricRequest, rhs: Google_Logging_V2_DeleteLogMetricRequest) -> Bool {
    if lhs.metricName != rhs.metricName {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
