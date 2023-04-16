import Foundation
import GRPC
import GCPTrace

public func defaultClientTraceInterceptors<Request, Response, DependencyType: GRPCDependency>(_ dependencyType: DependencyType.Type) -> [ClientInterceptor<Request, Response>] {
    [
        ClientTraceInterceptor(),
        ClientGoogleAuthInterceptor(dependencyType),
    ].compactMap { $0 }
}
