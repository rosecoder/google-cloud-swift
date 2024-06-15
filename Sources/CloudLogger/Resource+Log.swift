import Foundation
import CloudCore

private var resolvedEntryLabels: [String: String]?

extension Environment {

    func logName(label: String) async -> String {
        await "projects/\(projectID)/logs/\(label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? label)"
    }

    var type: String {
        switch self {
        case .k8sContainer:
            return "k8s_container"
        case .cloudRunJob:
            return "cloud_run_job"
        case .cloudRunRevision:
            return "cloud_run_revision"
#if DEBUG
        case .localDevelopment:
            return ""
#endif
        }
    }

    var labels: [String: String] {
        get async {
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
            case .cloudRunJob(let jobName, _, _, _, _):
                return await [
                    "project_id": projectID,
                    "job_name": jobName,
                    "location": locationID
                ]
            case .cloudRunRevision(let serviceName, let revisionName, let configurationName, _):
                return await [
                    "project_id": projectID,
                    "service_name": serviceName,
                    "revision_name": revisionName,
                    "location": locationID,
                    "configuration_name": configurationName
                ]
#if DEBUG
            case .localDevelopment:
                return [:]
#endif
            }
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
            case .cloudRunJob(_, let executionName, let taskIndex, let taskAttempt, _):
                resolvedEntryLabels = [
                    "instanceId": instanceID ?? "0",
                    "run.googleapis.com/execution_name": executionName,
                    "run.googleapis.com/task_attempt": String(taskAttempt),
                    "run.googleapis.com/task_index": String(taskIndex),
                ]
            case .cloudRunRevision:
                resolvedEntryLabels = [
                    "instanceId": instanceID ?? "0"
                ]
#if DEBUG
        case .localDevelopment:
                resolvedEntryLabels = [:]
#endif
            }
        }

        return resolvedEntryLabels ?? [:]
    }
}
