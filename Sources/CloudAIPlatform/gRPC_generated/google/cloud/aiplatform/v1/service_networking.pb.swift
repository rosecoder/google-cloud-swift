// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/service_networking.proto
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

/// Represents configuration for private service connect.
public struct Google_Cloud_Aiplatform_V1_PrivateServiceConnectConfig: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. If true, expose the IndexEndpoint via private service connect.
  public var enablePrivateServiceConnect: Bool = false

  /// A list of Projects from which the forwarding rule will target the service
  /// attachment.
  public var projectAllowlist: [String] = []

  /// Output only. The name of the generated service attachment resource.
  /// This is only populated if the endpoint is deployed with
  /// PrivateServiceConnect.
  public var serviceAttachment: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// PscAutomatedEndpoints defines the output of the forwarding rule
/// automatically created by each PscAutomationConfig.
public struct Google_Cloud_Aiplatform_V1_PscAutomatedEndpoints: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Corresponding project_id in pscAutomationConfigs
  public var projectID: String = String()

  /// Corresponding network in pscAutomationConfigs.
  public var network: String = String()

  /// Ip Address created by the automated forwarding rule.
  public var matchAddress: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_PrivateServiceConnectConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".PrivateServiceConnectConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "enable_private_service_connect"),
    2: .standard(proto: "project_allowlist"),
    5: .standard(proto: "service_attachment"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBoolField(value: &self.enablePrivateServiceConnect) }()
      case 2: try { try decoder.decodeRepeatedStringField(value: &self.projectAllowlist) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.serviceAttachment) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.enablePrivateServiceConnect != false {
      try visitor.visitSingularBoolField(value: self.enablePrivateServiceConnect, fieldNumber: 1)
    }
    if !self.projectAllowlist.isEmpty {
      try visitor.visitRepeatedStringField(value: self.projectAllowlist, fieldNumber: 2)
    }
    if !self.serviceAttachment.isEmpty {
      try visitor.visitSingularStringField(value: self.serviceAttachment, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_PrivateServiceConnectConfig, rhs: Google_Cloud_Aiplatform_V1_PrivateServiceConnectConfig) -> Bool {
    if lhs.enablePrivateServiceConnect != rhs.enablePrivateServiceConnect {return false}
    if lhs.projectAllowlist != rhs.projectAllowlist {return false}
    if lhs.serviceAttachment != rhs.serviceAttachment {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_PscAutomatedEndpoints: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".PscAutomatedEndpoints"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "project_id"),
    2: .same(proto: "network"),
    3: .standard(proto: "match_address"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.projectID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.network) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.matchAddress) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.projectID.isEmpty {
      try visitor.visitSingularStringField(value: self.projectID, fieldNumber: 1)
    }
    if !self.network.isEmpty {
      try visitor.visitSingularStringField(value: self.network, fieldNumber: 2)
    }
    if !self.matchAddress.isEmpty {
      try visitor.visitSingularStringField(value: self.matchAddress, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_PscAutomatedEndpoints, rhs: Google_Cloud_Aiplatform_V1_PscAutomatedEndpoints) -> Bool {
    if lhs.projectID != rhs.projectID {return false}
    if lhs.network != rhs.network {return false}
    if lhs.matchAddress != rhs.matchAddress {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}