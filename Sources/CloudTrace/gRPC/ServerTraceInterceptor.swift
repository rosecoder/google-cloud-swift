import Foundation
import GRPC
import NIO
import Logging

private enum TraceKey: UserInfoKey {
  typealias Value = Trace
}

extension UserInfo {

    fileprivate var trace: Trace? {
        get { self[TraceKey.self] }
        set { self[TraceKey.self] = newValue }
    }
}

public final class ServerTraceInterceptor<Request, Response>: GRPC.ServerInterceptor<Request, Response> {

    public override func receive(_ part: GRPCServerRequestPart<Request>, context: ServerInterceptorContext<Request, Response>) {
        switch part {
        case .metadata(var headers):

            // Reusable trace included in header?
            if
                let headerValue = headers.first(name: "X-Cloud-Trace-Context"),
                let trace = Trace(headerValue: headerValue, childrenSameProcessAsParent: false)
            {
                context.userInfo.trace = trace
                context.receive(part)
            } else {

                // No, create our own trace instead
                let trace = Trace(
                    named: context.path,
                    kind: .server,
                    attributes: [:]
                )
                context.userInfo.trace = trace
                headers.replaceOrAdd(name: "X-Cloud-Trace-Context", value: trace.headerValue)
                context.receive(.metadata(headers))
            }
        case .end:

            // Make sure we only trace server request handling
            context.userInfo.trace?.rootSpan?.restart()

            context.receive(part)
        default:
            context.receive(part)
        }
    }

    public override func send(_ part: GRPCServerResponsePart<Response>, promise: EventLoopPromise<Void>?, context: ServerInterceptorContext<Request, Response>) {
        switch part {
        case .end(let status, _):

            // End trace of root span is owned by this process
            context.userInfo.trace?.rootSpan?.end(statusCode: status.code)

            // Logging
            let logger = Logger(label: "grpc.request", trace: context.userInfo.trace)
            if status.isOk {
                logger.debug("\(context.path): OK")
            } else {
                switch status.code {
                case
                        .unknown,
                        .deadlineExceeded,
                        .unimplemented,
                        .internalError,
                        .unavailable:
                    logger.error("\(context.path): \(status)")
                default:
                    logger.info("\(context.path): \(status)")
                }
            }
        default:
            break
        }
        context.send(part, promise: promise)
    }
}
