import Foundation
import GRPC
import CloudTrace

public func defaultClientInterceptors<Request: Sendable, Response, DependencyType: GRPCDependency>(_ dependencyType: DependencyType.Type) -> [ClientInterceptor<Request, Response>] {
    [
        ClientTraceInterceptor(),
        ClientGoogleAuthInterceptor(dependencyType),
    ].compactMap { $0 }
}
