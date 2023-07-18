import Foundation
import GRPC

public struct Trace: Codable, Equatable {

    public let id: Identifier

    public var rootSpan: Span?
    public let spanID: Span.Identifier

    public let childrenSameProcessAsParent: Bool

    /// Initializes a new unique trace with no parent.
    public init(named name: String, kind: Span.Kind, attributes: [String: AttributableValue] = [:]) {
        self.id = Identifier()

        let rootSpanID = Span.Identifier()
        self.spanID = rootSpanID
        self.rootSpan = Span(
            traceID: id,
            parentID: nil,
            sameProcessAsParent: true, // TODO: Should this be true, false or nil? Documentation do not mention this.
            id: rootSpanID,
            kind: kind,
            name: name,
            attributes: attributes
        )
        self.childrenSameProcessAsParent = true
    }

    /// Initializes a existing trace.
    /// - Parameters:
    ///   - id: Identifier of the trace.
    ///   - spanID: Optional. Identifier of the parent span id.
    public init(id: Identifier, spanID: Span.Identifier, childrenSameProcessAsParent: Bool = false) {
        self.id = id
        self.rootSpan = nil
        self.spanID = spanID
        self.childrenSameProcessAsParent = childrenSameProcessAsParent
    }

    /// Initialize from a trace header (`X-Cloud-Trace-Context`).
    /// - Parameter headerValue: Value of header.
    ///
    /// Valid format: `TRACE_ID/SPAN_ID;o=TRACE_TRUE`
    public init?(headerValue: String, childrenSameProcessAsParent: Bool = false) {
        guard
            let optionsValueIndex = headerValue.firstIndex(of: "="),
            headerValue[headerValue.index(optionsValueIndex, offsetBy: -1)] == "o", // TODO: Check bounds
            headerValue[headerValue.index(optionsValueIndex, offsetBy: 1)] == "1", // TODO: Check bounds

            let slashIndex = headerValue.firstIndex(of: "/"),
            let optionsIndex = headerValue.firstIndex(of: ";"),

            let id = Identifier(stringValue: String(headerValue[..<slashIndex])),
            let spanID = Span.Identifier(stringValue: String(headerValue[headerValue.index(slashIndex, offsetBy: 1)..<optionsIndex]))
        else {
            return nil
        }

        self.id = id
        self.spanID = spanID
        self.rootSpan = nil
        self.childrenSameProcessAsParent = childrenSameProcessAsParent
    }

    public var headerValue: String {
        id.stringValue + "/" + spanID.stringValue + ";o=1"
    }

    // MARK: - Child spans

    /// Initializes a new span operation with this trace as parent.
    /// - Parameters:
    ///   - name: Display name of the operation. Limited to 128 bytes.
    ///   - attributes: Initial key value attributes for the operation. Can later be modified during the operation or on end.
    /// - Returns: New span operation.
    public func span(named name: String, kind: Span.Kind, attributes: [String: AttributableValue] = [:]) -> Span {
        Span(
            traceID: id,
            parentID: spanID,
            sameProcessAsParent: childrenSameProcessAsParent,
            id: Span.Identifier(),
            kind: kind,
            name: name,
            attributes: attributes
        )
    }

    @inlinable
    public func recordSpan(named name: String, kind: Span.Kind, attributes: [String: AttributableValue] = [:], closure: (inout Span) async throws -> Void) async rethrows {
        var span = self.span(named: name, kind: kind, attributes: attributes)
        do {
            try await closure(&span)
            span.end(statusCode: .ok)
        } catch {
            span.end(error: error)
            throw error
        }
    }

    @inlinable
    public func recordSpan<Element>(named name: String, kind: Span.Kind, attributes: [String: AttributableValue] = [:], closure: (inout Span) async throws -> Element) async rethrows -> Element {
        var span = self.span(named: name, kind: kind, attributes: attributes)
        do {
            let element = try await closure(&span)
            span.end(statusCode: .ok)
            return element
        } catch {
            span.end(error: error)
            throw error
        }
    }

    // MARK: - Ending

    @inlinable
    public mutating func end(
        status: Span.Status? = nil,
        additionalAttributes: [String: AttributableValue] = [:]
    ) {
        precondition(rootSpan != nil)
        rootSpan?.end(status: status, additionalAttributes: additionalAttributes)
    }

    @inlinable
    public mutating func end(
        statusCode: Span.Status.Code,
        additionalAttributes: [String: AttributableValue] = [:]
    ) {
        precondition(rootSpan != nil)
        rootSpan?.end(statusCode: statusCode, additionalAttributes: additionalAttributes)
    }

    @inlinable
    public mutating func end(
        error: Error,
        additionalAttributes: [String: AttributableValue] = [:]
    ) {
        precondition(rootSpan != nil)
        rootSpan?.end(error: error, additionalAttributes: additionalAttributes)
    }

    // MARK: - Equatable

    public static func ==(lhs: Trace, rhs: Trace) -> Bool {
        lhs.id == rhs.id
    }
}
