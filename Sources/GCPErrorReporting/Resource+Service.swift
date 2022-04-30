import Foundation
import GCPCore

extension Resource {

    var projectID: String {
        switch self {
        case .k8sContainer(let projectID, _, _, _, _, _):
            return projectID
        }
    }

    var serviceContext: RequestBody.ServiceContext {
        switch self {
        case .k8sContainer(_, _, _, _, _, let containerName):
            return .init(
                service: containerName,
                version: "0" // TODO: Set version
            )
        }
    }
}
