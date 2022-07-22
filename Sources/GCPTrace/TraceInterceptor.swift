import Foundation
import GRPC
import NIO

extension GRPC.CallOptions {

    public init(context: Context) {
        guard let trace = context.trace else {
            self.init()
            return
        }

        self.init(customMetadata: .init([
            ("X-Cloud-Trace-Context", trace.headerValue),
        ]))
    }
}

public final class TraceInterceptor<Request, Response>: GRPC.ClientInterceptor<Request, Response> {

    private var span: Span?

    public override func send(_ part: GRPCClientRequestPart<Request>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Request, Response>) {
        defer {
            context.send(part, promise: promise)
        }
        guard context.type == .unary else {
            return
        }

        switch part {
        case .metadata(let headers):
            if
                let headerValue = headers.first(name: "X-Cloud-Trace-Context"),
                let trace = Trace(headerValue: headerValue)
            {
                span = Span(
                    traceID: trace.id,
                    parentID: trace.spanID,
                    sameProcessAsParent: true,
                    id: Span.Identifier(),
                    name: context.path,
                    attributes: [:]
                )
            }
        default:
            break
        }
    }

    public override func receive(_ part: GRPCClientResponsePart<Response>, context: ClientInterceptorContext<Request, Response>) {
        defer {
            context.receive(part)
        }
        guard context.type == .unary else {
            return
        }

        switch part {
        case .end(let status, _):
            span?.end(statusCode: status.code)
        default:
            break
        }
    }
}
