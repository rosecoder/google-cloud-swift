import Foundation

public struct Trace: Codable, Equatable {

    public let id: Identifier

    public var rootSpan: Span?
    public let spanID: Span.Identifier

    /// Initializes a new unique trace with no parent.
    public init(named name: String, attributes: [String: AttributableValue] = [:]) {
        self.id = Identifier()

        let rootSpanID = Span.Identifier()
        self.spanID = rootSpanID
        self.rootSpan = Span(
            traceID: id,
            parentID: nil,
            sameProcessAsParent: true, // TODO: Should this be true, false or nil? Documentation do not mention this.
            id: rootSpanID,
            name: name,
            attributes: attributes
        )
    }

    /// Initializes a existing trace.
    /// - Parameters:
    ///   - id: Identifier of the trace.
    ///   - spanID: Optional. Identifier of the parent span id.
    public init(id: Identifier, spanID: Span.Identifier) {
        self.id = id
        self.rootSpan = nil
        self.spanID = spanID
    }

    // MARK: - Child spans

    /// Initializes a new span operation with this trace as parent.
    /// - Parameters:
    ///   - name: Display name of the operation. Limited to 128 bytes.
    ///   - attributes: Initial key value attributes for the operation. Can later be modified during the operation or on end.
    /// - Returns: New span operation.
    public func span(named name: String, attributes: [String: AttributableValue] = [:]) -> Span {
        precondition(rootSpan?.ended == nil, "Child span of trace was requested, but root span already ended.")

        return Span(
            traceID: id,
            parentID: spanID,
            sameProcessAsParent: rootSpan != nil,
            id: Span.Identifier(),
            name: name,
            attributes: attributes
        )
    }

    @inlinable
    public func recordSpan(named name: String, attributes: [String: AttributableValue] = [:], closure: (inout Span) async throws -> Void) async rethrows {
        var span = self.span(named: name, attributes: attributes)
        do {
            try await closure(&span)
            span.end(statusCode: .ok)
        } catch {
            span.end(error: error)
            throw error
        }
    }

    @inlinable
    public func recordSpan<Element>(named name: String, attributes: [String: AttributableValue] = [:], closure: (inout Span) async throws -> Element) async rethrows -> Element {
        var span = self.span(named: name, attributes: attributes)
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
