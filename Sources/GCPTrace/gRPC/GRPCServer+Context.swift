import Foundation
import GRPC
import Logging

extension GRPCAsyncServerCallContext: Context {

    public var logger: Logger {
        get {
            if request.logger.label == "io.grpc" {
                return Logger(label: "grpc.request", trace: trace)
            }
            return request.logger
        }
        set { request.logger = newValue }
    }

    public var trace: Trace? {
        get {
            guard let traceHeader = request.headers.first(name: "X-Cloud-Trace-Context") else {
                return nil
            }
            return Trace(headerValue: traceHeader, childrenSameProcessAsParent: true)
        }
        set {
            // Do nothing. Can not change a trace not owned by the same process.
        }
    }
}
