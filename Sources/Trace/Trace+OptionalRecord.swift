import Foundation

extension Optional where Wrapped == Trace {

    @inlinable
    public func recordSpan(named name: String, kind: Span.Kind, attributes: [String: AttributableValue] = [:], closure: (inout Span?) async throws -> Void) async rethrows {
        if let trace = self {
            try await trace.recordSpan(named: name, kind: kind, attributes: attributes) { span in
                var optional = span as Span?
                try await closure(&optional)
                span = optional!
            }
        } else {
            var span: Span? = nil
            try await closure(&span)
        }
    }

    @inlinable
    public func recordSpan<Element>(named name: String, kind: Span.Kind, attributes: [String: AttributableValue] = [:], closure: (inout Span?) async throws -> Element) async rethrows -> Element {
        if let trace = self {
            return try await trace.recordSpan(named: name, kind: kind, attributes: attributes) { span in
                var optional = span as Span?
                let element = try await closure(&optional)
                span = optional!
                return element
            }
        } else {
            var span: Span? = nil
            return try await closure(&span)
        }
    }
}
