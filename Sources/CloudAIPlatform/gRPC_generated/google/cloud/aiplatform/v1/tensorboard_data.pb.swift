// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/tensorboard_data.proto
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

/// All the data stored in a TensorboardTimeSeries.
public struct Google_Cloud_Aiplatform_V1_TimeSeriesData: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The ID of the TensorboardTimeSeries, which will become the final
  /// component of the TensorboardTimeSeries' resource name
  public var tensorboardTimeSeriesID: String = String()

  /// Required. Immutable. The value type of this time series. All the values in
  /// this time series data must match this value type.
  public var valueType: Google_Cloud_Aiplatform_V1_TensorboardTimeSeries.ValueType = .unspecified

  /// Required. Data points in this time series.
  public var values: [Google_Cloud_Aiplatform_V1_TimeSeriesDataPoint] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// A TensorboardTimeSeries data point.
public struct Google_Cloud_Aiplatform_V1_TimeSeriesDataPoint: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Value of this time series data point.
  public var value: Google_Cloud_Aiplatform_V1_TimeSeriesDataPoint.OneOf_Value? = nil

  /// A scalar value.
  public var scalar: Google_Cloud_Aiplatform_V1_Scalar {
    get {
      if case .scalar(let v)? = value {return v}
      return Google_Cloud_Aiplatform_V1_Scalar()
    }
    set {value = .scalar(newValue)}
  }

  /// A tensor value.
  public var tensor: Google_Cloud_Aiplatform_V1_TensorboardTensor {
    get {
      if case .tensor(let v)? = value {return v}
      return Google_Cloud_Aiplatform_V1_TensorboardTensor()
    }
    set {value = .tensor(newValue)}
  }

  /// A blob sequence value.
  public var blobs: Google_Cloud_Aiplatform_V1_TensorboardBlobSequence {
    get {
      if case .blobs(let v)? = value {return v}
      return Google_Cloud_Aiplatform_V1_TensorboardBlobSequence()
    }
    set {value = .blobs(newValue)}
  }

  /// Wall clock timestamp when this data point is generated by the end user.
  public var wallTime: SwiftProtobuf.Google_Protobuf_Timestamp {
    get {return _wallTime ?? SwiftProtobuf.Google_Protobuf_Timestamp()}
    set {_wallTime = newValue}
  }
  /// Returns true if `wallTime` has been explicitly set.
  public var hasWallTime: Bool {return self._wallTime != nil}
  /// Clears the value of `wallTime`. Subsequent reads from it will return its default value.
  public mutating func clearWallTime() {self._wallTime = nil}

  /// Step index of this data point within the run.
  public var step: Int64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Value of this time series data point.
  public enum OneOf_Value: Equatable, Sendable {
    /// A scalar value.
    case scalar(Google_Cloud_Aiplatform_V1_Scalar)
    /// A tensor value.
    case tensor(Google_Cloud_Aiplatform_V1_TensorboardTensor)
    /// A blob sequence value.
    case blobs(Google_Cloud_Aiplatform_V1_TensorboardBlobSequence)

  }

  public init() {}

  fileprivate var _wallTime: SwiftProtobuf.Google_Protobuf_Timestamp? = nil
}

/// One point viewable on a scalar metric plot.
public struct Google_Cloud_Aiplatform_V1_Scalar: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Value of the point at this step / timestamp.
  public var value: Double = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// One point viewable on a tensor metric plot.
public struct Google_Cloud_Aiplatform_V1_TensorboardTensor: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. Serialized form of
  /// https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/framework/tensor.proto
  public var value: Data = Data()

  /// Optional. Version number of TensorProto used to serialize
  /// [value][google.cloud.aiplatform.v1.TensorboardTensor.value].
  public var versionNumber: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// One point viewable on a blob metric plot, but mostly just a wrapper message
/// to work around repeated fields can't be used directly within `oneof` fields.
public struct Google_Cloud_Aiplatform_V1_TensorboardBlobSequence: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// List of blobs contained within the sequence.
  public var values: [Google_Cloud_Aiplatform_V1_TensorboardBlob] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// One blob (e.g, image, graph) viewable on a blob metric plot.
public struct Google_Cloud_Aiplatform_V1_TensorboardBlob: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Output only. A URI safe key uniquely identifying a blob. Can be used to
  /// locate the blob stored in the Cloud Storage bucket of the consumer project.
  public var id: String = String()

  /// Optional. The bytes of the blob is not present unless it's returned by the
  /// ReadTensorboardBlobData endpoint.
  public var data: Data = Data()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_TimeSeriesData: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TimeSeriesData"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "tensorboard_time_series_id"),
    2: .standard(proto: "value_type"),
    3: .same(proto: "values"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.tensorboardTimeSeriesID) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.valueType) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.values) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.tensorboardTimeSeriesID.isEmpty {
      try visitor.visitSingularStringField(value: self.tensorboardTimeSeriesID, fieldNumber: 1)
    }
    if self.valueType != .unspecified {
      try visitor.visitSingularEnumField(value: self.valueType, fieldNumber: 2)
    }
    if !self.values.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.values, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_TimeSeriesData, rhs: Google_Cloud_Aiplatform_V1_TimeSeriesData) -> Bool {
    if lhs.tensorboardTimeSeriesID != rhs.tensorboardTimeSeriesID {return false}
    if lhs.valueType != rhs.valueType {return false}
    if lhs.values != rhs.values {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_TimeSeriesDataPoint: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TimeSeriesDataPoint"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    3: .same(proto: "scalar"),
    4: .same(proto: "tensor"),
    5: .same(proto: "blobs"),
    1: .standard(proto: "wall_time"),
    2: .same(proto: "step"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._wallTime) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.step) }()
      case 3: try {
        var v: Google_Cloud_Aiplatform_V1_Scalar?
        var hadOneofValue = false
        if let current = self.value {
          hadOneofValue = true
          if case .scalar(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.value = .scalar(v)
        }
      }()
      case 4: try {
        var v: Google_Cloud_Aiplatform_V1_TensorboardTensor?
        var hadOneofValue = false
        if let current = self.value {
          hadOneofValue = true
          if case .tensor(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.value = .tensor(v)
        }
      }()
      case 5: try {
        var v: Google_Cloud_Aiplatform_V1_TensorboardBlobSequence?
        var hadOneofValue = false
        if let current = self.value {
          hadOneofValue = true
          if case .blobs(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.value = .blobs(v)
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
    try { if let v = self._wallTime {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if self.step != 0 {
      try visitor.visitSingularInt64Field(value: self.step, fieldNumber: 2)
    }
    switch self.value {
    case .scalar?: try {
      guard case .scalar(let v)? = self.value else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }()
    case .tensor?: try {
      guard case .tensor(let v)? = self.value else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    }()
    case .blobs?: try {
      guard case .blobs(let v)? = self.value else { preconditionFailure() }
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    }()
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_TimeSeriesDataPoint, rhs: Google_Cloud_Aiplatform_V1_TimeSeriesDataPoint) -> Bool {
    if lhs.value != rhs.value {return false}
    if lhs._wallTime != rhs._wallTime {return false}
    if lhs.step != rhs.step {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_Scalar: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Scalar"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularDoubleField(value: &self.value) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_Scalar, rhs: Google_Cloud_Aiplatform_V1_Scalar) -> Bool {
    if lhs.value != rhs.value {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_TensorboardTensor: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TensorboardTensor"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
    2: .standard(proto: "version_number"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.value) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.versionNumber) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.value.isEmpty {
      try visitor.visitSingularBytesField(value: self.value, fieldNumber: 1)
    }
    if self.versionNumber != 0 {
      try visitor.visitSingularInt32Field(value: self.versionNumber, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_TensorboardTensor, rhs: Google_Cloud_Aiplatform_V1_TensorboardTensor) -> Bool {
    if lhs.value != rhs.value {return false}
    if lhs.versionNumber != rhs.versionNumber {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_TensorboardBlobSequence: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TensorboardBlobSequence"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "values"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.values) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.values.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.values, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_TensorboardBlobSequence, rhs: Google_Cloud_Aiplatform_V1_TensorboardBlobSequence) -> Bool {
    if lhs.values != rhs.values {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_TensorboardBlob: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".TensorboardBlob"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "data"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.data) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.data.isEmpty {
      try visitor.visitSingularBytesField(value: self.data, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_TensorboardBlob, rhs: Google_Cloud_Aiplatform_V1_TensorboardBlob) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.data != rhs.data {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
