import Foundation
import GCPCore

private var resolvedEntryLabels: [String: String]?

extension Resource {

    func logName(label: String) -> String {
        switch self {
        case .k8sContainer(let projectID, _, _, _, _, _):
            return "projects/\(projectID)/logs/\(label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? label)"
        }
    }

    var labels: [String: String] {
        switch self {
        case .k8sContainer(let projectID, let location, let clusterName, let namespaceName, let podName, let containerName):
            return [
                "project_id": projectID,
                "location": location,
                "cluster_name": clusterName,
                "namespace_name": namespaceName,
                "pod_name": podName,
                "container_name": containerName,
            ]
        }
    }

    var entryLabels: [String: String] {
        if resolvedEntryLabels == nil {
            switch self {
            case .k8sContainer(_, _, _, _, let podName, _):
                let podNameComponents = podName.components(separatedBy: "-")
                guard podNameComponents.count >= 3
                    else { return [:] }

                resolvedEntryLabels = [
                    "k8s-pod/pod-template-hash": podNameComponents[podNameComponents.count - 2],
                    "k8s-pod/run": podNameComponents[0..<podNameComponents.count - 2].joined(separator: "-"),
                ]
            }
        }

        return resolvedEntryLabels ?? [:]
    }
}
