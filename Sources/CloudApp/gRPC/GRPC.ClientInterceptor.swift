import Foundation
import GRPC
import Trace

public func defaultClientInterceptors<Request, Response, DependencyType: GRPCDependency>(_ dependencyType: DependencyType.Type) -> [ClientInterceptor<Request, Response>] {
    [
        ClientTraceInterceptor(),
        ClientGoogleAuthInterceptor(dependencyType),
    ].compactMap { $0 }
}
