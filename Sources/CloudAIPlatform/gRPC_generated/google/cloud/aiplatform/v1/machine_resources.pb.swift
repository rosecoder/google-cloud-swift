// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: google/cloud/aiplatform/v1/machine_resources.proto
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

/// Specification of a single machine.
public struct Google_Cloud_Aiplatform_V1_MachineSpec: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Immutable. The type of the machine.
  ///
  /// See the [list of machine types supported for
  /// prediction](https://cloud.google.com/vertex-ai/docs/predictions/configure-compute#machine-types)
  ///
  /// See the [list of machine types supported for custom
  /// training](https://cloud.google.com/vertex-ai/docs/training/configure-compute#machine-types).
  ///
  /// For [DeployedModel][google.cloud.aiplatform.v1.DeployedModel] this field is
  /// optional, and the default value is `n1-standard-2`. For
  /// [BatchPredictionJob][google.cloud.aiplatform.v1.BatchPredictionJob] or as
  /// part of [WorkerPoolSpec][google.cloud.aiplatform.v1.WorkerPoolSpec] this
  /// field is required.
  public var machineType: String = String()

  /// Immutable. The type of accelerator(s) that may be attached to the machine
  /// as per
  /// [accelerator_count][google.cloud.aiplatform.v1.MachineSpec.accelerator_count].
  public var acceleratorType: Google_Cloud_Aiplatform_V1_AcceleratorType = .unspecified

  /// The number of accelerators to attach to the machine.
  public var acceleratorCount: Int32 = 0

  /// Immutable. The topology of the TPUs. Corresponds to the TPU topologies
  /// available from GKE. (Example: tpu_topology: "2x2x1").
  public var tpuTopology: String = String()

  /// Optional. Immutable. Configuration controlling how this resource pool
  /// consumes reservation.
  public var reservationAffinity: Google_Cloud_Aiplatform_V1_ReservationAffinity {
    get {return _reservationAffinity ?? Google_Cloud_Aiplatform_V1_ReservationAffinity()}
    set {_reservationAffinity = newValue}
  }
  /// Returns true if `reservationAffinity` has been explicitly set.
  public var hasReservationAffinity: Bool {return self._reservationAffinity != nil}
  /// Clears the value of `reservationAffinity`. Subsequent reads from it will return its default value.
  public mutating func clearReservationAffinity() {self._reservationAffinity = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _reservationAffinity: Google_Cloud_Aiplatform_V1_ReservationAffinity? = nil
}

/// A description of resources that are dedicated to a DeployedModel, and
/// that need a higher degree of manual configuration.
public struct Google_Cloud_Aiplatform_V1_DedicatedResources: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. Immutable. The specification of a single machine used by the
  /// prediction.
  public var machineSpec: Google_Cloud_Aiplatform_V1_MachineSpec {
    get {return _machineSpec ?? Google_Cloud_Aiplatform_V1_MachineSpec()}
    set {_machineSpec = newValue}
  }
  /// Returns true if `machineSpec` has been explicitly set.
  public var hasMachineSpec: Bool {return self._machineSpec != nil}
  /// Clears the value of `machineSpec`. Subsequent reads from it will return its default value.
  public mutating func clearMachineSpec() {self._machineSpec = nil}

  /// Required. Immutable. The minimum number of machine replicas this
  /// DeployedModel will be always deployed on. This value must be greater than
  /// or equal to 1.
  ///
  /// If traffic against the DeployedModel increases, it may dynamically be
  /// deployed onto more replicas, and as traffic decreases, some of these extra
  /// replicas may be freed.
  public var minReplicaCount: Int32 = 0

  /// Immutable. The maximum number of replicas this DeployedModel may be
  /// deployed on when the traffic against it increases. If the requested value
  /// is too large, the deployment will error, but if deployment succeeds then
  /// the ability to scale the model to that many replicas is guaranteed (barring
  /// service outages). If traffic against the DeployedModel increases beyond
  /// what its replicas at maximum may handle, a portion of the traffic will be
  /// dropped. If this value is not provided, will use
  /// [min_replica_count][google.cloud.aiplatform.v1.DedicatedResources.min_replica_count]
  /// as the default value.
  ///
  /// The value of this field impacts the charge against Vertex CPU and GPU
  /// quotas. Specifically, you will be charged for (max_replica_count *
  /// number of cores in the selected machine type) and (max_replica_count *
  /// number of GPUs per replica in the selected machine type).
  public var maxReplicaCount: Int32 = 0

  /// Immutable. The metric specifications that overrides a resource
  /// utilization metric (CPU utilization, accelerator's duty cycle, and so on)
  /// target value (default to 60 if not set). At most one entry is allowed per
  /// metric.
  ///
  /// If
  /// [machine_spec.accelerator_count][google.cloud.aiplatform.v1.MachineSpec.accelerator_count]
  /// is above 0, the autoscaling will be based on both CPU utilization and
  /// accelerator's duty cycle metrics and scale up when either metrics exceeds
  /// its target value while scale down if both metrics are under their target
  /// value. The default target value is 60 for both metrics.
  ///
  /// If
  /// [machine_spec.accelerator_count][google.cloud.aiplatform.v1.MachineSpec.accelerator_count]
  /// is 0, the autoscaling will be based on CPU utilization metric only with
  /// default target value 60 if not explicitly set.
  ///
  /// For example, in the case of Online Prediction, if you want to override
  /// target CPU utilization to 80, you should set
  /// [autoscaling_metric_specs.metric_name][google.cloud.aiplatform.v1.AutoscalingMetricSpec.metric_name]
  /// to `aiplatform.googleapis.com/prediction/online/cpu/utilization` and
  /// [autoscaling_metric_specs.target][google.cloud.aiplatform.v1.AutoscalingMetricSpec.target]
  /// to `80`.
  public var autoscalingMetricSpecs: [Google_Cloud_Aiplatform_V1_AutoscalingMetricSpec] = []

  /// Optional. If true, schedule the deployment workload on [spot
  /// VMs](https://cloud.google.com/kubernetes-engine/docs/concepts/spot-vms).
  public var spot: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _machineSpec: Google_Cloud_Aiplatform_V1_MachineSpec? = nil
}

/// A description of resources that to large degree are decided by Vertex AI,
/// and require only a modest additional configuration.
/// Each Model supporting these resources documents its specific guidelines.
public struct Google_Cloud_Aiplatform_V1_AutomaticResources: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Immutable. The minimum number of replicas this DeployedModel will be always
  /// deployed on. If traffic against it increases, it may dynamically be
  /// deployed onto more replicas up to
  /// [max_replica_count][google.cloud.aiplatform.v1.AutomaticResources.max_replica_count],
  /// and as traffic decreases, some of these extra replicas may be freed. If the
  /// requested value is too large, the deployment will error.
  public var minReplicaCount: Int32 = 0

  /// Immutable. The maximum number of replicas this DeployedModel may be
  /// deployed on when the traffic against it increases. If the requested value
  /// is too large, the deployment will error, but if deployment succeeds then
  /// the ability to scale the model to that many replicas is guaranteed (barring
  /// service outages). If traffic against the DeployedModel increases beyond
  /// what its replicas at maximum may handle, a portion of the traffic will be
  /// dropped. If this value is not provided, a no upper bound for scaling under
  /// heavy traffic will be assume, though Vertex AI may be unable to scale
  /// beyond certain replica number.
  public var maxReplicaCount: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// A description of resources that are used for performing batch operations, are
/// dedicated to a Model, and need manual configuration.
public struct Google_Cloud_Aiplatform_V1_BatchDedicatedResources: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. Immutable. The specification of a single machine.
  public var machineSpec: Google_Cloud_Aiplatform_V1_MachineSpec {
    get {return _machineSpec ?? Google_Cloud_Aiplatform_V1_MachineSpec()}
    set {_machineSpec = newValue}
  }
  /// Returns true if `machineSpec` has been explicitly set.
  public var hasMachineSpec: Bool {return self._machineSpec != nil}
  /// Clears the value of `machineSpec`. Subsequent reads from it will return its default value.
  public mutating func clearMachineSpec() {self._machineSpec = nil}

  /// Immutable. The number of machine replicas used at the start of the batch
  /// operation. If not set, Vertex AI decides starting number, not greater than
  /// [max_replica_count][google.cloud.aiplatform.v1.BatchDedicatedResources.max_replica_count]
  public var startingReplicaCount: Int32 = 0

  /// Immutable. The maximum number of machine replicas the batch operation may
  /// be scaled to. The default value is 10.
  public var maxReplicaCount: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _machineSpec: Google_Cloud_Aiplatform_V1_MachineSpec? = nil
}

/// Statistics information about resource consumption.
public struct Google_Cloud_Aiplatform_V1_ResourcesConsumed: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Output only. The number of replica hours used. Note that many replicas may
  /// run in parallel, and additionally any given work may be queued for some
  /// time. Therefore this value is not strictly related to wall time.
  public var replicaHours: Double = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// Represents the spec of disk options.
public struct Google_Cloud_Aiplatform_V1_DiskSpec: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Type of the boot disk (default is "pd-ssd").
  /// Valid values: "pd-ssd" (Persistent Disk Solid State Drive) or
  /// "pd-standard" (Persistent Disk Hard Disk Drive).
  public var bootDiskType: String = String()

  /// Size in GB of the boot disk (default is 100GB).
  public var bootDiskSizeGb: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// Represents the spec of [persistent
/// disk][https://cloud.google.com/compute/docs/disks/persistent-disks] options.
public struct Google_Cloud_Aiplatform_V1_PersistentDiskSpec: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Type of the disk (default is "pd-standard").
  /// Valid values: "pd-ssd" (Persistent Disk Solid State Drive)
  /// "pd-standard" (Persistent Disk Hard Disk Drive)
  /// "pd-balanced" (Balanced Persistent Disk)
  /// "pd-extreme" (Extreme Persistent Disk)
  public var diskType: String = String()

  /// Size in GB of the disk (default is 100GB).
  public var diskSizeGb: Int64 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// Represents a mount configuration for Network File System (NFS) to mount.
public struct Google_Cloud_Aiplatform_V1_NfsMount: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. IP address of the NFS server.
  public var server: String = String()

  /// Required. Source path exported from NFS server.
  /// Has to start with '/', and combined with the ip address, it indicates
  /// the source mount path in the form of `server:path`
  public var path: String = String()

  /// Required. Destination mount path. The NFS will be mounted for the user
  /// under /mnt/nfs/<mount_point>
  public var mountPoint: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// The metric specification that defines the target resource utilization
/// (CPU utilization, accelerator's duty cycle, and so on) for calculating the
/// desired replica count.
public struct Google_Cloud_Aiplatform_V1_AutoscalingMetricSpec: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Required. The resource metric name.
  /// Supported metrics:
  ///
  /// * For Online Prediction:
  /// * `aiplatform.googleapis.com/prediction/online/accelerator/duty_cycle`
  /// * `aiplatform.googleapis.com/prediction/online/cpu/utilization`
  public var metricName: String = String()

  /// The target resource utilization in percentage (1% - 100%) for the given
  /// metric; once the real usage deviates from the target by a certain
  /// percentage, the machine replicas change. The default value is 60
  /// (representing 60%) if not provided.
  public var target: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// A set of Shielded Instance options.
/// See [Images using supported Shielded VM
/// features](https://cloud.google.com/compute/docs/instances/modifying-shielded-vm).
public struct Google_Cloud_Aiplatform_V1_ShieldedVmConfig: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Defines whether the instance has [Secure
  /// Boot](https://cloud.google.com/compute/shielded-vm/docs/shielded-vm#secure-boot)
  /// enabled.
  ///
  /// Secure Boot helps ensure that the system only runs authentic software by
  /// verifying the digital signature of all boot components, and halting the
  /// boot process if signature verification fails.
  public var enableSecureBoot: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "google.cloud.aiplatform.v1"

extension Google_Cloud_Aiplatform_V1_MachineSpec: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".MachineSpec"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "machine_type"),
    2: .standard(proto: "accelerator_type"),
    3: .standard(proto: "accelerator_count"),
    4: .standard(proto: "tpu_topology"),
    5: .standard(proto: "reservation_affinity"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.machineType) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.acceleratorType) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.acceleratorCount) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.tpuTopology) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._reservationAffinity) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.machineType.isEmpty {
      try visitor.visitSingularStringField(value: self.machineType, fieldNumber: 1)
    }
    if self.acceleratorType != .unspecified {
      try visitor.visitSingularEnumField(value: self.acceleratorType, fieldNumber: 2)
    }
    if self.acceleratorCount != 0 {
      try visitor.visitSingularInt32Field(value: self.acceleratorCount, fieldNumber: 3)
    }
    if !self.tpuTopology.isEmpty {
      try visitor.visitSingularStringField(value: self.tpuTopology, fieldNumber: 4)
    }
    try { if let v = self._reservationAffinity {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_MachineSpec, rhs: Google_Cloud_Aiplatform_V1_MachineSpec) -> Bool {
    if lhs.machineType != rhs.machineType {return false}
    if lhs.acceleratorType != rhs.acceleratorType {return false}
    if lhs.acceleratorCount != rhs.acceleratorCount {return false}
    if lhs.tpuTopology != rhs.tpuTopology {return false}
    if lhs._reservationAffinity != rhs._reservationAffinity {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_DedicatedResources: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".DedicatedResources"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "machine_spec"),
    2: .standard(proto: "min_replica_count"),
    3: .standard(proto: "max_replica_count"),
    4: .standard(proto: "autoscaling_metric_specs"),
    5: .same(proto: "spot"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._machineSpec) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.minReplicaCount) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.maxReplicaCount) }()
      case 4: try { try decoder.decodeRepeatedMessageField(value: &self.autoscalingMetricSpecs) }()
      case 5: try { try decoder.decodeSingularBoolField(value: &self.spot) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._machineSpec {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if self.minReplicaCount != 0 {
      try visitor.visitSingularInt32Field(value: self.minReplicaCount, fieldNumber: 2)
    }
    if self.maxReplicaCount != 0 {
      try visitor.visitSingularInt32Field(value: self.maxReplicaCount, fieldNumber: 3)
    }
    if !self.autoscalingMetricSpecs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.autoscalingMetricSpecs, fieldNumber: 4)
    }
    if self.spot != false {
      try visitor.visitSingularBoolField(value: self.spot, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_DedicatedResources, rhs: Google_Cloud_Aiplatform_V1_DedicatedResources) -> Bool {
    if lhs._machineSpec != rhs._machineSpec {return false}
    if lhs.minReplicaCount != rhs.minReplicaCount {return false}
    if lhs.maxReplicaCount != rhs.maxReplicaCount {return false}
    if lhs.autoscalingMetricSpecs != rhs.autoscalingMetricSpecs {return false}
    if lhs.spot != rhs.spot {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_AutomaticResources: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".AutomaticResources"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "min_replica_count"),
    2: .standard(proto: "max_replica_count"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.minReplicaCount) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.maxReplicaCount) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.minReplicaCount != 0 {
      try visitor.visitSingularInt32Field(value: self.minReplicaCount, fieldNumber: 1)
    }
    if self.maxReplicaCount != 0 {
      try visitor.visitSingularInt32Field(value: self.maxReplicaCount, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_AutomaticResources, rhs: Google_Cloud_Aiplatform_V1_AutomaticResources) -> Bool {
    if lhs.minReplicaCount != rhs.minReplicaCount {return false}
    if lhs.maxReplicaCount != rhs.maxReplicaCount {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_BatchDedicatedResources: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".BatchDedicatedResources"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "machine_spec"),
    2: .standard(proto: "starting_replica_count"),
    3: .standard(proto: "max_replica_count"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._machineSpec) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.startingReplicaCount) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.maxReplicaCount) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._machineSpec {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if self.startingReplicaCount != 0 {
      try visitor.visitSingularInt32Field(value: self.startingReplicaCount, fieldNumber: 2)
    }
    if self.maxReplicaCount != 0 {
      try visitor.visitSingularInt32Field(value: self.maxReplicaCount, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_BatchDedicatedResources, rhs: Google_Cloud_Aiplatform_V1_BatchDedicatedResources) -> Bool {
    if lhs._machineSpec != rhs._machineSpec {return false}
    if lhs.startingReplicaCount != rhs.startingReplicaCount {return false}
    if lhs.maxReplicaCount != rhs.maxReplicaCount {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_ResourcesConsumed: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ResourcesConsumed"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "replica_hours"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularDoubleField(value: &self.replicaHours) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.replicaHours.bitPattern != 0 {
      try visitor.visitSingularDoubleField(value: self.replicaHours, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_ResourcesConsumed, rhs: Google_Cloud_Aiplatform_V1_ResourcesConsumed) -> Bool {
    if lhs.replicaHours != rhs.replicaHours {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_DiskSpec: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".DiskSpec"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "boot_disk_type"),
    2: .standard(proto: "boot_disk_size_gb"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.bootDiskType) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.bootDiskSizeGb) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.bootDiskType.isEmpty {
      try visitor.visitSingularStringField(value: self.bootDiskType, fieldNumber: 1)
    }
    if self.bootDiskSizeGb != 0 {
      try visitor.visitSingularInt32Field(value: self.bootDiskSizeGb, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_DiskSpec, rhs: Google_Cloud_Aiplatform_V1_DiskSpec) -> Bool {
    if lhs.bootDiskType != rhs.bootDiskType {return false}
    if lhs.bootDiskSizeGb != rhs.bootDiskSizeGb {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_PersistentDiskSpec: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".PersistentDiskSpec"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "disk_type"),
    2: .standard(proto: "disk_size_gb"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.diskType) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.diskSizeGb) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.diskType.isEmpty {
      try visitor.visitSingularStringField(value: self.diskType, fieldNumber: 1)
    }
    if self.diskSizeGb != 0 {
      try visitor.visitSingularInt64Field(value: self.diskSizeGb, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_PersistentDiskSpec, rhs: Google_Cloud_Aiplatform_V1_PersistentDiskSpec) -> Bool {
    if lhs.diskType != rhs.diskType {return false}
    if lhs.diskSizeGb != rhs.diskSizeGb {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_NfsMount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".NfsMount"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "server"),
    2: .same(proto: "path"),
    3: .standard(proto: "mount_point"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.server) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.path) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.mountPoint) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.server.isEmpty {
      try visitor.visitSingularStringField(value: self.server, fieldNumber: 1)
    }
    if !self.path.isEmpty {
      try visitor.visitSingularStringField(value: self.path, fieldNumber: 2)
    }
    if !self.mountPoint.isEmpty {
      try visitor.visitSingularStringField(value: self.mountPoint, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_NfsMount, rhs: Google_Cloud_Aiplatform_V1_NfsMount) -> Bool {
    if lhs.server != rhs.server {return false}
    if lhs.path != rhs.path {return false}
    if lhs.mountPoint != rhs.mountPoint {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_AutoscalingMetricSpec: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".AutoscalingMetricSpec"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "metric_name"),
    2: .same(proto: "target"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.metricName) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.target) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.metricName.isEmpty {
      try visitor.visitSingularStringField(value: self.metricName, fieldNumber: 1)
    }
    if self.target != 0 {
      try visitor.visitSingularInt32Field(value: self.target, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_AutoscalingMetricSpec, rhs: Google_Cloud_Aiplatform_V1_AutoscalingMetricSpec) -> Bool {
    if lhs.metricName != rhs.metricName {return false}
    if lhs.target != rhs.target {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Google_Cloud_Aiplatform_V1_ShieldedVmConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ShieldedVmConfig"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "enable_secure_boot"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBoolField(value: &self.enableSecureBoot) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.enableSecureBoot != false {
      try visitor.visitSingularBoolField(value: self.enableSecureBoot, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: Google_Cloud_Aiplatform_V1_ShieldedVmConfig, rhs: Google_Cloud_Aiplatform_V1_ShieldedVmConfig) -> Bool {
    if lhs.enableSecureBoot != rhs.enableSecureBoot {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}