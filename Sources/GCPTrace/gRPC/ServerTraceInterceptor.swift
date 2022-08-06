import Foundation
import GRPC
import NIO

private enum SpanKey: UserInfoKey {
  typealias Value = Span
}

extension UserInfo {

    fileprivate var span: Span? {
        get { self[SpanKey.self] }
        set { self[SpanKey.self] = newValue }
    }
}

public final class ServerTraceInterceptor<Request, Response>: GRPC.ServerInterceptor<Request, Response> {

    public override func receive(_ part: GRPCServerRequestPart<Request>, context: ServerInterceptorContext<Request, Response>) {
        switch part {
        case .metadata(var headers):
            if
                let headerValue = headers.first(name: "X-Cloud-Trace-Context"),
                let trace = Trace(headerValue: headerValue, childrenSameProcessAsParent: false)
            {
                let span = Span(
                    traceID: trace.id,
                    parentID: trace.spanID,
                    sameProcessAsParent: false,
                    id: Span.Identifier(),
                    kind: .server,
                    name: context.path,
                    attributes: [:]
                )
                context.userInfo.span = span
                headers.replaceOrAdd(name: "X-Cloud-Trace-Context", value: trace.id.stringValue + "/" + span.id.stringValue + ";o=1")
                context.receive(.metadata(headers))
            } else {
                // TODO: Create new trace?
                context.receive(part)
            }
        case .end:
            context.userInfo.span?.restart()
            context.receive(part)
        default:
            context.receive(part)
        }
    }

    public override func send(_ part: GRPCServerResponsePart<Response>, promise: EventLoopPromise<Void>?, context: ServerInterceptorContext<Request, Response>) {
        switch part {
        case .end(let status, _):
            context.userInfo.span?.end(statusCode: status.code)
        default:
            break
        }
        context.send(part, promise: promise)
    }
}
