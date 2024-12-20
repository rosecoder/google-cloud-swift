// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/tool.proto
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

/// Tool details that the model may use to generate response.
///
/// A `Tool` is a piece of code that enables the system to interact with
/// external systems to perform an action, or set of actions, outside of
/// knowledge and scope of the model. A Tool object should contain exactly
/// one type of Tool (e.g FunctionDeclaration, Retrieval or
/// GoogleSearchRetrieval).
public struct Google_Cloud_Aiplatform_V1_Tool: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Optional. Function tool type.
  /// One or more function declarations to be passed to the model along with the
  /// current user query. Model may decide to call a subset of these functions
  /// by populating [FunctionCall][content.part.function_call] in the response.
  /// User should provide a [FunctionResponse][content.part.function_response]
  /// for each function call in the next turn. Based on the function responses,
  /// Model will generate the final response back to the user.
  /// Maximum 64 function declarations can be provided.
  public var functionDeclarations: [Google_Cloud_Aiplatform_V1_FunctionDeclaration] = []

  /// Optional. Retrieval tool type.
  /// System will always execute the provided retrieval tool(s) to get external
  /// knowledge to answer the prompt. Retrieval results are presented to the
  /// model for generation.
  public var retrieval: Google_Cloud_Aiplatform_V1_Retrieval {
    get {return _retrieval ?? Google_Cloud_Aiplatform_V1_Retrieval()}
    set {_retrieval = newValue}
  }
  /// Returns true if `retrieval` has been explicitly set.
  public var hasRetrieval: Bool {return self._retrieval != nil}
  /// Clears the value of `retrieval`. Subsequent reads from it will return its default value.
  public mutating func clearRetrieval() {self._retrieval = nil}

  /// Optional. GoogleSearchRetrieval tool type.
  /// Specialized retrieval tool that is powered by Google search.
  public var googleSearchRetrieval: Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval {
    get {return _googleSearchRetrieval ?? Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval()}
    set {_googleSearchRetrieval = newValue}
  }
  /// Returns true if `googleSearchRetrieval` has been explicitly set.
  public var hasGoogleSearchRetrieval: Bool {return self._googleSearchRetrieval != nil}
  /// Clears the value of `googleSearchRetrieval`. Subsequent reads from it will return its default value.
  public mutating func clearGoogleSearchRetrieval() {self._googleSearchRetrieval = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _retrieval: Google_Cloud_Aiplatform_V1_Retrieval? = nil
  fileprivate var _googleSearchRetrieval: Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval? = nil
}

/// Structured representation of a function declaration as defined by the
/// [OpenAPI 3.0 specification](https://spec.openapis.org/oas/v3.0.3). Included
/// in this declaration are the function name and parameters. This
/// FunctionDeclaration is a representation of a block of code that can be used
/// as a `Tool` by the model and executed by the client.
public struct Google_Cloud_Aiplatform_V1_FunctionDeclaration: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The name of the function to call.
  /// Must start with a letter or an underscore.
  /// Must be a-z, A-Z, 0-9, or contain underscores, dots and dashes, with a
  /// maximum length of 64.
  public var name: String = String()

  /// Optional. Description and purpose of the function.
  /// Model uses it to decide how and whether to call the function.
  public var description_p: String = String()

  /// Optional. Describes the parameters to this function in JSON Schema Object
  /// format. Reflects the Open API 3.03 Parameter Object. string Key: the name
  /// of the parameter. Parameter names are case sensitive. Schema Value: the
  /// Schema defining the type used for the parameter. For function with no
  /// parameters, this can be left unset. Parameter names must start with a
  /// letter or an underscore and must only contain chars a-z, A-Z, 0-9, or
  /// underscores with a maximum length of 64. Example with 1 required and 1
  /// optional parameter: type: OBJECT properties:
  ///  param1:
  ///    type: STRING
  ///  param2:
  ///    type: INTEGER
  /// required:
  ///  - param1
  public var parameters: Google_Cloud_Aiplatform_V1_Schema {
    get {return _parameters ?? Google_Cloud_Aiplatform_V1_Schema()}
    set {_parameters = newValue}
  }
  /// Returns true if `parameters` has been explicitly set.
  public var hasParameters: Bool {return self._parameters != nil}
  /// Clears the value of `parameters`. Subsequent reads from it will return its default value.
  public mutating func clearParameters() {self._parameters = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _parameters: Google_Cloud_Aiplatform_V1_Schema? = nil
}

/// A predicted [FunctionCall] returned from the model that contains a string
/// representing the [FunctionDeclaration.name] and a structured JSON object
/// containing the parameters and their values.
public struct Google_Cloud_Aiplatform_V1_FunctionCall: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The name of the function to call.
  /// Matches [FunctionDeclaration.name].
  public var name: String = String()

  /// Optional. Required. The function parameters and values in JSON object
  /// format. See [FunctionDeclaration.parameters] for parameter details.
  public var args: SwiftProtobuf.Google_Protobuf_Struct {
    get {return _args ?? SwiftProtobuf.Google_Protobuf_Struct()}
    set {_args = newValue}
  }
  /// Returns true if `args` has been explicitly set.
  public var hasArgs: Bool {return self._args != nil}
  /// Clears the value of `args`. Subsequent reads from it will return its default value.
  public mutating func clearArgs() {self._args = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _args: SwiftProtobuf.Google_Protobuf_Struct? = nil
}

/// The result output from a [FunctionCall] that contains a string representing
/// the [FunctionDeclaration.name] and a structured JSON object containing any
/// output from the function is used as context to the model. This should contain
/// the result of a [FunctionCall] made based on model prediction.
public struct Google_Cloud_Aiplatform_V1_FunctionResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The name of the function to call.
  /// Matches [FunctionDeclaration.name] and [FunctionCall.name].
  public var name: String = String()

  /// Required. The function response in JSON object format.
  public var response: SwiftProtobuf.Google_Protobuf_Struct {
    get {return _response ?? SwiftProtobuf.Google_Protobuf_Struct()}
    set {_response = newValue}
  }
  /// Returns true if `response` has been explicitly set.
  public var hasResponse: Bool {return self._response != nil}
  /// Clears the value of `response`. Subsequent reads from it will return its default value.
  public mutating func clearResponse() {self._response = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _response: SwiftProtobuf.Google_Protobuf_Struct? = nil
}

/// Defines a retrieval tool that model can call to access external knowledge.
public struct Google_Cloud_Aiplatform_V1_Retrieval: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The source of the retrieval.
  public var source: Google_Cloud_Aiplatform_V1_Retrieval.OneOf_Source? = nil

  /// Set to use data source powered by Vertex AI Search.
  public var vertexAiSearch: Google_Cloud_Aiplatform_V1_VertexAISearch {
    get {
      if case .vertexAiSearch(let v)? = source {return v}
      return Google_Cloud_Aiplatform_V1_VertexAISearch()
    }
    set {source = .vertexAiSearch(newValue)}
  }

  /// Optional. Deprecated. This option is no longer supported.
  ///
  /// NOTE: This field was marked as deprecated in the .proto file.
  public var disableAttribution: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// The source of the retrieval.
  public enum OneOf_Source: Equatable, Sendable {
    /// Set to use data source powered by Vertex AI Search.
    case vertexAiSearch(Google_Cloud_Aiplatform_V1_VertexAISearch)

  }

  public init() {}
}

/// Retrieve from Vertex AI Search datastore for grounding.
/// See https://cloud.google.com/vertex-ai-search-and-conversation
public struct Google_Cloud_Aiplatform_V1_VertexAISearch: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. Fully-qualified Vertex AI Search's datastore resource ID.
  /// Format:
  /// `projects/{project}/locations/{location}/collections/{collection}/dataStores/{dataStore}`
  public var datastore: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// Tool to retrieve public web data for grounding, powered by Google.
public struct Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// Tool config. This config is shared for all tools provided in the request.
public struct Google_Cloud_Aiplatform_V1_ToolConfig: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Optional. Function calling config.
  public var functionCallingConfig: Google_Cloud_Aiplatform_V1_FunctionCallingConfig {
    get {return _functionCallingConfig ?? Google_Cloud_Aiplatform_V1_FunctionCallingConfig()}
    set {_functionCallingConfig = newValue}
  }
  /// Returns true if `functionCallingConfig` has been explicitly set.
  public var hasFunctionCallingConfig: Bool {return self._functionCallingConfig != nil}
  /// Clears the value of `functionCallingConfig`. Subsequent reads from it will return its default value.
  public mutating func clearFunctionCallingConfig() {self._functionCallingConfig = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _functionCallingConfig: Google_Cloud_Aiplatform_V1_FunctionCallingConfig? = nil
}

/// Function calling config.
public struct Google_Cloud_Aiplatform_V1_FunctionCallingConfig: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Optional. Function calling mode.
  public var mode: Google_Cloud_Aiplatform_V1_FunctionCallingConfig.Mode = .unspecified

  /// Optional. Function names to call. Only set when the Mode is ANY. Function
  /// names should match [FunctionDeclaration.name]. With mode set to ANY, model
  /// will predict a function call from the set of function names provided.
  public var allowedFunctionNames: [String] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Function calling mode.
  public enum Mode: SwiftProtobuf.Enum, Swift.CaseIterable {
    public typealias RawValue = Int

    /// Unspecified function calling mode. This value should not be used.
    case unspecified // = 0

    /// Default model behavior, model decides to predict either a function call
    /// or a natural language response.
    case auto // = 1

    /// Model is constrained to always predicting a function call only.
    /// If "allowed_function_names" are set, the predicted function call will be
    /// limited to any one of "allowed_function_names", else the predicted
    /// function call will be any one of the provided "function_declarations".
    case any // = 2

    /// Model will not predict any function call. Model behavior is same as when
    /// not passing any function declarations.
    case none // = 3
    case UNRECOGNIZED(Int)

    public init() {
      self = .unspecified
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unspecified
      case 1: self = .auto
      case 2: self = .any
      case 3: self = .none
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    public var rawValue: Int {
      switch self {
      case .unspecified: return 0
      case .auto: return 1
      case .any: return 2
      case .none: return 3
      case .UNRECOGNIZED(let i): return i
      }
    }

    // The compiler won't synthesize support with the UNRECOGNIZED case.
    public static let allCases: [Google_Cloud_Aiplatform_V1_FunctionCallingConfig.Mode] = [
      .unspecified,
      .auto,
      .any,
      .none,
    ]

  }

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_Tool: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Tool"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "function_declarations"),
    2: .same(proto: "retrieval"),
    3: .standard(proto: "google_search_retrieval"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.functionDeclarations) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._retrieval) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._googleSearchRetrieval) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.functionDeclarations.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.functionDeclarations, fieldNumber: 1)
    }
    try { if let v = self._retrieval {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try { if let v = self._googleSearchRetrieval {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_Tool, rhs: Google_Cloud_Aiplatform_V1_Tool) -> Bool {
    if lhs.functionDeclarations != rhs.functionDeclarations {return false}
    if lhs._retrieval != rhs._retrieval {return false}
    if lhs._googleSearchRetrieval != rhs._googleSearchRetrieval {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FunctionDeclaration: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FunctionDeclaration"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "description"),
    3: .same(proto: "parameters"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._parameters) }()
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
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 2)
    }
    try { if let v = self._parameters {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FunctionDeclaration, rhs: Google_Cloud_Aiplatform_V1_FunctionDeclaration) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs._parameters != rhs._parameters {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FunctionCall: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FunctionCall"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "args"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._args) }()
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
    try { if let v = self._args {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FunctionCall, rhs: Google_Cloud_Aiplatform_V1_FunctionCall) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs._args != rhs._args {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FunctionResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FunctionResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
    2: .same(proto: "response"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._response) }()
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
    try { if let v = self._response {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FunctionResponse, rhs: Google_Cloud_Aiplatform_V1_FunctionResponse) -> Bool {
    if lhs.name != rhs.name {return false}
    if lhs._response != rhs._response {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_Retrieval: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Retrieval"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    2: .standard(proto: "vertex_ai_search"),
    3: .standard(proto: "disable_attribution"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 2: try {
        var v: Google_Cloud_Aiplatform_V1_VertexAISearch?
        var hadOneofValue = false
        if let current = self.source {
          hadOneofValue = true
          if case .vertexAiSearch(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {
          if hadOneofValue {try decoder.handleConflictingOneOf()}
          self.source = .vertexAiSearch(v)
        }
      }()
      case 3: try { try decoder.decodeSingularBoolField(value: &self.disableAttribution) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if case .vertexAiSearch(let v)? = self.source {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    if self.disableAttribution != false {
      try visitor.visitSingularBoolField(value: self.disableAttribution, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_Retrieval, rhs: Google_Cloud_Aiplatform_V1_Retrieval) -> Bool {
    if lhs.source != rhs.source {return false}
    if lhs.disableAttribution != rhs.disableAttribution {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_VertexAISearch: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".VertexAISearch"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "datastore"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.datastore) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.datastore.isEmpty {
      try visitor.visitSingularStringField(value: self.datastore, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_VertexAISearch, rhs: Google_Cloud_Aiplatform_V1_VertexAISearch) -> Bool {
    if lhs.datastore != rhs.datastore {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".GoogleSearchRetrieval"
  public static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    // Load everything into unknown fields
    while try decoder.nextFieldNumber() != nil {}
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval, rhs: Google_Cloud_Aiplatform_V1_GoogleSearchRetrieval) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_ToolConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ToolConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "function_calling_config"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._functionCallingConfig) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._functionCallingConfig {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_ToolConfig, rhs: Google_Cloud_Aiplatform_V1_ToolConfig) -> Bool {
    if lhs._functionCallingConfig != rhs._functionCallingConfig {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FunctionCallingConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".FunctionCallingConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "mode"),
    2: .standard(proto: "allowed_function_names"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.mode) }()
      case 2: try { try decoder.decodeRepeatedStringField(value: &self.allowedFunctionNames) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.mode != .unspecified {
      try visitor.visitSingularEnumField(value: self.mode, fieldNumber: 1)
    }
    if !self.allowedFunctionNames.isEmpty {
      try visitor.visitRepeatedStringField(value: self.allowedFunctionNames, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_FunctionCallingConfig, rhs: Google_Cloud_Aiplatform_V1_FunctionCallingConfig) -> Bool {
    if lhs.mode != rhs.mode {return false}
    if lhs.allowedFunctionNames != rhs.allowedFunctionNames {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_FunctionCallingConfig.Mode: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "MODE_UNSPECIFIED"),
    1: .same(proto: "AUTO"),
    2: .same(proto: "ANY"),
    3: .same(proto: "NONE"),
  ]
}
