import Foundation
import CloudCore
import Trace
import Logging

protocol Subscriber: Dependency {

    static var logger: Logger { get }
}

protocol IncomingRawMessage {

    var id: String { get }
    var attributes: [String: String] { get }
}

extension Subscriber {

    static func messageContext(subscriptionName: String, rawMessage: IncomingRawMessage) -> Context {
        var context: Context = HandlerContext(
            logger: {
                var messageLogger = Logger(label: logger.label + ".message")
                messageLogger[metadataKey: "pubsub.message"] = .string(rawMessage.id)
                return messageLogger
            }(),
            trace: Trace(
                named: subscriptionName,
                kind: .consumer,
                attributes: [
                    "message": rawMessage.id,
                ]
            )
        )
        if let trace = context.trace {
            context.logger.addMetadata(for: trace)
        }

        // Link to parent trace if included in message
        if
            let rawSourceTraceID = rawMessage.attributes["__traceID"],
            let rawSourceSpanID = rawMessage.attributes["__spanID"],
            let traceID = Trace.Identifier(stringValue: rawSourceTraceID),
            let spanID = Span.Identifier(stringValue: rawSourceSpanID)
        {
            context.trace?.rootSpan?.links.append(.init(
                trace: Trace(id: traceID, spanID: spanID),
                kind: .parent
            ))
        }

        return context
    }
}
