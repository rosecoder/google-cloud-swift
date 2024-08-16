import Foundation
import GRPC

public struct Span: Sendable, Equatable, Codable {

    let traceID: Trace.Identifier
    let parentID: Identifier?
    let sameProcessAsParent: Bool

    public let id: Identifier

    public let kind: Kind

    /// Display name of the span show in shown in Google Cloud Console. Limited to 128 bytes.
    public let name: String

    /// Key value attributes for the span shown in Google Cloud Console. Limited to 32 keys.
    public var attributes: [String: AttributableValue]

    /// Date of when the operation started.
    public var started: Date

    /// Date of when the operation ended or nil if the operation has not ended yet.
    public private(set) var ended: Date?

    public var status: Status?

    public var links: [Span.Link]

    init(
        traceID: Trace.Identifier,
        parentID: Identifier?,
        sameProcessAsParent: Bool,
        id: Identifier,
        kind: Kind,
        name: String,
        attributes: [String: AttributableValue],
        links: [Link] = []
    ) {
        self.traceID = traceID
        self.parentID = parentID
        self.sameProcessAsParent = sameProcessAsParent
        self.id = id
        self.kind = kind
        self.name = name
        self.attributes = attributes
        self.started = Date()
        self.links = links
    }

    // MARK: - Starting

    /// Resets the start time to now.
    public mutating func restart() {
        started = Date()
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

        let span = self
        Task {
            await Tracing.shared.bufferWrite(span: span)
        }
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

    // MARK: - Equatable

    public static func ==(lhs: Span, rhs: Span) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case traceID
        case parentID
        case sameProcessAsParent
        case id
        case name
        case attributes
        case started
        case ended
        case status
        case links
        case kind
    }

    private struct GenericStringKey: CodingKey {

        let stringValue: String
        var intValue: Int? { Int(stringValue) }

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(traceID, forKey: .traceID)
        try container.encode(parentID, forKey: .parentID)
        try container.encode(sameProcessAsParent, forKey: .sameProcessAsParent)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(started, forKey: .started)
        try container.encode(ended, forKey: .ended)
        try container.encode(status, forKey: .status)
        try container.encode(links, forKey: .links)
        try container.encode(kind, forKey: .kind)

        var attributesContainer = container.nestedContainer(keyedBy: GenericStringKey.self, forKey: .attributes)
        for (key, value) in attributes {
            try attributesContainer.encode(value._codableValue, forKey: GenericStringKey(stringValue: key))
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.traceID = try container.decode(Trace.Identifier.self, forKey: .traceID)
        self.parentID = try container.decodeIfPresent(Identifier.self, forKey: .parentID)
        self.sameProcessAsParent = try container.decode(Bool.self, forKey: .sameProcessAsParent)
        self.id = try container.decode(Identifier.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.started = try container.decode(Date.self, forKey: .started)
        self.ended = try container.decodeIfPresent(Date.self, forKey: .ended)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
        self.links = try container.decodeIfPresent([Link].self, forKey: .links) ?? []
        self.kind = try container.decodeIfPresent(Kind.self, forKey: .kind) ?? .internal

        let attributesContainer = try container.nestedContainer(keyedBy: GenericStringKey.self, forKey: .attributes)
        self.attributes = [:]
        for key in attributesContainer.allKeys {
            self.attributes[key.stringValue] = try attributesContainer
                .decode(AttributableValueCodableValue.self, forKey: GenericStringKey(stringValue: key.stringValue))
                .attributableValue
        }
    }
}
