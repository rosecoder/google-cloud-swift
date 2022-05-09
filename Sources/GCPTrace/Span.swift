import Foundation
import GRPC

public struct Span {

    let traceID: Trace.Identifier
    let parentID: Identifier?
    let sameProcessAsParent: Bool

    public let id: Identifier

    /// Display name of the span show in shown in Google Cloud Console. Limited to 128 bytes.
    public let name: String

    /// Key value attributes for the span shown in Google Cloud Console. Limited to 32 keys.
    public var attributes: [String: AttributableValue]

    /// Date of when the operation started.
    public let started: Date

    /// Date of when the operation ended or nil if the operation has not ended yet.
    public private(set) var ended: Date?

    public var status: Status?

    init(traceID: Trace.Identifier, parentID: Identifier?, sameProcessAsParent: Bool, id: Identifier, name: String, attributes: [String: AttributableValue]) {
        self.traceID = traceID
        self.parentID = parentID
        self.sameProcessAsParent = sameProcessAsParent
        self.id = id
        self.name = name
        self.attributes = attributes
        self.started = Date()
    }

    // MARK: - Ending

    /// Ends the span operation, updates attributes and schedule it for writing to Google Cloud.
    ///
    /// This method can only be called once! The span must not be already ended.
    ///
    /// Status is overwritten if already set. Attributes are overwritten if key already exists.
    ///
    /// Any modification to the span will not be sent to Google Cloud after this method is called.
    public mutating func end(
        status: Status? = nil,
        additionalAttributes: [String: AttributableValue] = [:]
    ) {
        precondition(ended == nil, "Span already ended.")
        ended = Date()

        self.status = status
        for (key, value) in additionalAttributes {
            attributes[key] = value
        }

        Tracing.bufferWrite(span: self)
    }

    public mutating func end(
        statusCode: Status.Code,
        additionalAttributes: [String: AttributableValue] = [:]
    ) {
        end(status: Status(code: statusCode), additionalAttributes: additionalAttributes)
    }

    public mutating func end(
        error: Error,
        additionalAttributes: [String: AttributableValue] = [:]
    ) {
        if let statusTransformable = error as? GRPCStatusTransformable {
            let grpcStatus = statusTransformable.makeGRPCStatus()
            end(status: Status(
                code: grpcStatus.code,
                message: grpcStatus.message
            ), additionalAttributes: additionalAttributes)
            return
        }
        if error is CancellationError {
            end(status: Status(code: .cancelled), additionalAttributes: additionalAttributes)
            return
        }
        end(status: Status(code: .unknown, message: "\(error)"), additionalAttributes: additionalAttributes)
    }

    public func abort() {
        // Currently this method do nothig, but it may be used in the future for keeping track of expected spans
    }
}
