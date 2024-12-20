// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/evaluated_annotation.proto
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

/// True positive, false positive, or false negative.
///
/// EvaluatedAnnotation is only available under ModelEvaluationSlice with slice
/// of `annotationSpec` dimension.
public struct Google_Cloud_Aiplatform_V1_EvaluatedAnnotation: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Output only. Type of the EvaluatedAnnotation.
  public var type: Google_Cloud_Aiplatform_V1_EvaluatedAnnotation.EvaluatedAnnotationType = .unspecified

  /// Output only. The model predicted annotations.
  ///
  /// For true positive, there is one and only one prediction, which matches the
  /// only one ground truth annotation in
  /// [ground_truths][google.cloud.aiplatform.v1.EvaluatedAnnotation.ground_truths].
  ///
  /// For false positive, there is one and only one prediction, which doesn't
  /// match any ground truth annotation of the corresponding
  /// [data_item_view_id][EvaluatedAnnotation.data_item_view_id].
  ///
  /// For false negative, there are zero or more predictions which are similar to
  /// the only ground truth annotation in
  /// [ground_truths][google.cloud.aiplatform.v1.EvaluatedAnnotation.ground_truths]
  /// but not enough for a match.
  ///
  /// The schema of the prediction is stored in
  /// [ModelEvaluation.annotation_schema_uri][google.cloud.aiplatform.v1.ModelEvaluation.annotation_schema_uri]
  public var predictions: [SwiftProtobuf.Google_Protobuf_Value] = []

  /// Output only. The ground truth Annotations, i.e. the Annotations that exist
  /// in the test data the Model is evaluated on.
  ///
  /// For true positive, there is one and only one ground truth annotation, which
  /// matches the only prediction in
  /// [predictions][google.cloud.aiplatform.v1.EvaluatedAnnotation.predictions].
  ///
  /// For false positive, there are zero or more ground truth annotations that
  /// are similar to the only prediction in
  /// [predictions][google.cloud.aiplatform.v1.EvaluatedAnnotation.predictions],
  /// but not enough for a match.
  ///
  /// For false negative, there is one and only one ground truth annotation,
  /// which doesn't match any predictions created by the model.
  ///
  /// The schema of the ground truth is stored in
  /// [ModelEvaluation.annotation_schema_uri][google.cloud.aiplatform.v1.ModelEvaluation.annotation_schema_uri]
  public var groundTruths: [SwiftProtobuf.Google_Protobuf_Value] = []

  /// Output only. The data item payload that the Model predicted this
  /// EvaluatedAnnotation on.
  public var dataItemPayload: SwiftProtobuf.Google_Protobuf_Value {
    get {return _dataItemPayload ?? SwiftProtobuf.Google_Protobuf_Value()}
    set {_dataItemPayload = newValue}
  }
  /// Returns true if `dataItemPayload` has been explicitly set.
  public var hasDataItemPayload: Bool {return self._dataItemPayload != nil}
  /// Clears the value of `dataItemPayload`. Subsequent reads from it will return its default value.
  public mutating func clearDataItemPayload() {self._dataItemPayload = nil}

  /// Output only. ID of the EvaluatedDataItemView under the same ancestor
  /// ModelEvaluation. The EvaluatedDataItemView consists of all ground truths
  /// and predictions on
  /// [data_item_payload][google.cloud.aiplatform.v1.EvaluatedAnnotation.data_item_payload].
  public var evaluatedDataItemViewID: String = String()

  /// Explanations of
  /// [predictions][google.cloud.aiplatform.v1.EvaluatedAnnotation.predictions].
  /// Each element of the explanations indicates the explanation for one
  /// explanation Method.
  ///
  /// The attributions list in the
  /// [EvaluatedAnnotationExplanation.explanation][google.cloud.aiplatform.v1.EvaluatedAnnotationExplanation.explanation]
  /// object corresponds to the
  /// [predictions][google.cloud.aiplatform.v1.EvaluatedAnnotation.predictions]
  /// list. For example, the second element in the attributions list explains the
  /// second element in the predictions list.
  public var explanations: [Google_Cloud_Aiplatform_V1_EvaluatedAnnotationExplanation] = []

  /// Annotations of model error analysis results.
  public var errorAnalysisAnnotations: [Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Describes the type of the EvaluatedAnnotation. The type is determined
  public enum EvaluatedAnnotationType: SwiftProtobuf.Enum, Swift.CaseIterable {
    public typealias RawValue = Int

    /// Invalid value.
    case unspecified // = 0

    /// The EvaluatedAnnotation is a true positive. It has a prediction created
    /// by the Model and a ground truth Annotation which the prediction matches.
    case truePositive // = 1

    /// The EvaluatedAnnotation is false positive. It has a prediction created by
    /// the Model which does not match any ground truth annotation.
    case falsePositive // = 2

    /// The EvaluatedAnnotation is false negative. It has a ground truth
    /// annotation which is not matched by any of the model created predictions.
    case falseNegative // = 3
    case UNRECOGNIZED(Int)

    public init() {
      self = .unspecified
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .truePositive
      case 2: self = .falsePositive
      case 3: self = .falseNegative
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    public var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .truePositive: return 1
      case .falsePositive: return 2
      case .falseNegative: return 3
      case .UNRECOGNIZED(let i): return i
      }
    }

    // The compiler won't synthesize support with the UNRECOGNIZED case.
    public static let allCases: [Google_Cloud_Aiplatform_V1_EvaluatedAnnotation.EvaluatedAnnotationType] = [
      .unspecified,
      .truePositive,
      .falsePositive,
      .falseNegative,
    ]

  }

  public init() {}

  fileprivate var _dataItemPayload: SwiftProtobuf.Google_Protobuf_Value? = nil
}

/// Explanation result of the prediction produced by the Model.
public struct Google_Cloud_Aiplatform_V1_EvaluatedAnnotationExplanation: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Explanation type.
  ///
  /// For AutoML Image Classification models, possible values are:
  ///
  ///   * `image-integrated-gradients`
  ///   * `image-xrai`
  public var explanationType: String = String()

  /// Explanation attribution response details.
  public var explanation: Google_Cloud_Aiplatform_V1_Explanation {
    get {return _explanation ?? Google_Cloud_Aiplatform_V1_Explanation()}
    set {_explanation = newValue}
  }
  /// Returns true if `explanation` has been explicitly set.
  public var hasExplanation: Bool {return self._explanation != nil}
  /// Clears the value of `explanation`. Subsequent reads from it will return its default value.
  public mutating func clearExplanation() {self._explanation = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _explanation: Google_Cloud_Aiplatform_V1_Explanation? = nil
}

/// Model error analysis for each annotation.
public struct Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Attributed items for a given annotation, typically representing neighbors
  /// from the training sets constrained by the query type.
  public var attributedItems: [Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.AttributedItem] = []

  /// The query type used for finding the attributed items.
  public var queryType: Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.QueryType = .unspecified

  /// The outlier score of this annotated item. Usually defined as the min of all
  /// distances from attributed items.
  public var outlierScore: Double = 0

  /// The threshold used to determine if this annotation is an outlier or not.
  public var outlierThreshold: Double = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// The query type used for finding the attributed items.
  public enum QueryType: SwiftProtobuf.Enum, Swift.CaseIterable {
    public typealias RawValue = Int

    /// Unspecified query type for model error analysis.
    case unspecified // = 0

    /// Query similar samples across all classes in the dataset.
    case allSimilar // = 1

    /// Query similar samples from the same class of the input sample.
    case sameClassSimilar // = 2

    /// Query dissimilar samples from the same class of the input sample.
    case sameClassDissimilar // = 3
    case UNRECOGNIZED(Int)

    public init() {
      self = .unspecified
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .allSimilar
      case 2: self = .sameClassSimilar
      case 3: self = .sameClassDissimilar
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    public var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .allSimilar: return 1
      case .sameClassSimilar: return 2
      case .sameClassDissimilar: return 3
      case .UNRECOGNIZED(let i): return i
      }
    }

    // The compiler won't synthesize support with the UNRECOGNIZED case.
    public static let allCases: [Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.QueryType] = [
      .unspecified,
      .allSimilar,
      .sameClassSimilar,
      .sameClassDissimilar,
    ]

  }

  /// Attributed items for a given annotation, typically representing neighbors
  /// from the training sets constrained by the query type.
  public struct AttributedItem: Sendable {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// The unique ID for each annotation. Used by FE to allocate the annotation
    /// in DB.
    public var annotationResourceName: String = String()

    /// The distance of this item to the annotation.
    public var distance: Double = 0

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}
  }

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_EvaluatedAnnotation: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".EvaluatedAnnotation"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "type"),
    2: .same(proto: "predictions"),
    3: .standard(proto: "ground_truths"),
    5: .standard(proto: "data_item_payload"),
    6: .standard(proto: "evaluated_data_item_view_id"),
    8: .same(proto: "explanations"),
    9: .standard(proto: "error_analysis_annotations"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.type) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.predictions) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.groundTruths) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._dataItemPayload) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.evaluatedDataItemViewID) }()
      case 8: try { try decoder.decodeRepeatedMessageField(value: &self.explanations) }()
      case 9: try { try decoder.decodeRepeatedMessageField(value: &self.errorAnalysisAnnotations) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.type != .unspecified {
      try visitor.visitSingularEnumField(value: self.type, fieldNumber: 1)
    }
    if !self.predictions.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.predictions, fieldNumber: 2)
    }
    if !self.groundTruths.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.groundTruths, fieldNumber: 3)
    }
    try { if let v = self._dataItemPayload {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    if !self.evaluatedDataItemViewID.isEmpty {
      try visitor.visitSingularStringField(value: self.evaluatedDataItemViewID, fieldNumber: 6)
    }
    if !self.explanations.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.explanations, fieldNumber: 8)
    }
    if !self.errorAnalysisAnnotations.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.errorAnalysisAnnotations, fieldNumber: 9)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_EvaluatedAnnotation, rhs: Google_Cloud_Aiplatform_V1_EvaluatedAnnotation) -> Bool {
    if lhs.type != rhs.type {return false}
    if lhs.predictions != rhs.predictions {return false}
    if lhs.groundTruths != rhs.groundTruths {return false}
    if lhs._dataItemPayload != rhs._dataItemPayload {return false}
    if lhs.evaluatedDataItemViewID != rhs.evaluatedDataItemViewID {return false}
    if lhs.explanations != rhs.explanations {return false}
    if lhs.errorAnalysisAnnotations != rhs.errorAnalysisAnnotations {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_EvaluatedAnnotation.EvaluatedAnnotationType: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "EVALUATED_ANNOTATION_TYPE_UNSPECIFIED"),
    1: .same(proto: "TRUE_POSITIVE"),
    2: .same(proto: "FALSE_POSITIVE"),
    3: .same(proto: "FALSE_NEGATIVE"),
  ]
}

extension Google_Cloud_Aiplatform_V1_EvaluatedAnnotationExplanation: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".EvaluatedAnnotationExplanation"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "explanation_type"),
    2: .same(proto: "explanation"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.explanationType) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._explanation) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.explanationType.isEmpty {
      try visitor.visitSingularStringField(value: self.explanationType, fieldNumber: 1)
    }
    try { if let v = self._explanation {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_EvaluatedAnnotationExplanation, rhs: Google_Cloud_Aiplatform_V1_EvaluatedAnnotationExplanation) -> Bool {
    if lhs.explanationType != rhs.explanationType {return false}
    if lhs._explanation != rhs._explanation {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ErrorAnalysisAnnotation"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "attributed_items"),
    2: .standard(proto: "query_type"),
    3: .standard(proto: "outlier_score"),
    4: .standard(proto: "outlier_threshold"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.attributedItems) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.queryType) }()
      case 3: try { try decoder.decodeSingularDoubleField(value: &self.outlierScore) }()
      case 4: try { try decoder.decodeSingularDoubleField(value: &self.outlierThreshold) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.attributedItems.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.attributedItems, fieldNumber: 1)
    }
    if self.queryType != .unspecified {
      try visitor.visitSingularEnumField(value: self.queryType, fieldNumber: 2)
    }
    if self.outlierScore.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.outlierScore, fieldNumber: 3)
    }
    if self.outlierThreshold.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.outlierThreshold, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation, rhs: Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation) -> Bool {
    if lhs.attributedItems != rhs.attributedItems {return false}
    if lhs.queryType != rhs.queryType {return false}
    if lhs.outlierScore != rhs.outlierScore {return false}
    if lhs.outlierThreshold != rhs.outlierThreshold {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.QueryType: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "QUERY_TYPE_UNSPECIFIED"),
    1: .same(proto: "ALL_SIMILAR"),
    2: .same(proto: "SAME_CLASS_SIMILAR"),
    3: .same(proto: "SAME_CLASS_DISSIMILAR"),
  ]
}

extension Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.AttributedItem: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.protoMessageName + ".AttributedItem"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "annotation_resource_name"),
    2: .same(proto: "distance"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.annotationResourceName) }()
      case 2: try { try decoder.decodeSingularDoubleField(value: &self.distance) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.annotationResourceName.isEmpty {
      try visitor.visitSingularStringField(value: self.annotationResourceName, fieldNumber: 1)
    }
    if self.distance.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.distance, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.AttributedItem, rhs: Google_Cloud_Aiplatform_V1_ErrorAnalysisAnnotation.AttributedItem) -> Bool {
    if lhs.annotationResourceName != rhs.annotationResourceName {return false}
    if lhs.distance != rhs.distance {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
