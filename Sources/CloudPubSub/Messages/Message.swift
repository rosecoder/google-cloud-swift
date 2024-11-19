import Foundation
import Logging
import Tracing

public typealias _Message = Message

public protocol Message {

    associatedtype Incoming: IncomingMessage
    associatedtype Outgoing: OutgoingMessage
}

// MARK: - Outgoing

public protocol OutgoingMessage {

    var data: Data { get }
    var attributes: [String: String] { get }
}

// MARK: - Incoming

public protocol IncomingMessage {

    var id: String { get }
    var published: Date { get }

    init(
        id: String,
        published: Date,
        data: Data,
        attributes: [String: String],
        logger: inout Logger,
        span: any Span
    ) throws
}

#if DEBUG
extension IncomingMessage {

    public init(
        data: Data,
        attributes: [String: String] = [:]
    ) throws {
        var logger = Logger(label: "debug")
        let span = NoOpTracer.Span(context: .topLevel)
        try self.init(id: "0", published: Date(), data: data, attributes: attributes, logger: &logger, span: span)
    }
}
#endif

