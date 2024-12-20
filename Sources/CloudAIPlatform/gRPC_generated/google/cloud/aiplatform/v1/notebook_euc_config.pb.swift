// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/notebook_euc_config.proto
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

/// The euc configuration of NotebookRuntimeTemplate.
public struct Google_Cloud_Aiplatform_V1_NotebookEucConfig: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Input only. Whether EUC is disabled in this NotebookRuntimeTemplate.
  /// In proto3, the default value of a boolean is false. In this way, by default
  /// EUC will be enabled for NotebookRuntimeTemplate.
  public var eucDisabled: Bool = false

  /// Output only. Whether ActAs check is bypassed for service account attached
  /// to the VM. If false, we need ActAs check for the default Compute Engine
  /// Service account. When a Runtime is created, a VM is allocated using Default
  /// Compute Engine Service Account. Any user requesting to use this Runtime
  /// requires Service Account User (ActAs) permission over this SA. If true,
  /// Runtime owner is using EUC and does not require the above permission as VM
  /// no longer use default Compute Engine SA, but a P4SA.
  public var bypassActasCheck: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_NotebookEucConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".NotebookEucConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "euc_disabled"),
    2: .standard(proto: "bypass_actas_check"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBoolField(value: &self.eucDisabled) }()
      case 2: try { try decoder.decodeSingularBoolField(value: &self.bypassActasCheck) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.eucDisabled != false {
      try visitor.visitSingularBoolField(value: self.eucDisabled, fieldNumber: 1)
    }
    if self.bypassActasCheck != false {
      try visitor.visitSingularBoolField(value: self.bypassActasCheck, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_NotebookEucConfig, rhs: Google_Cloud_Aiplatform_V1_NotebookEucConfig) -> Bool {
    if lhs.eucDisabled != rhs.eucDisabled {return false}
    if lhs.bypassActasCheck != rhs.bypassActasCheck {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
