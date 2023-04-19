import Foundation

private var _current: Environment?
private var __projectID: String?

public enum Environment {
#if DEBUG
    case localDevelopment
#endif
    case k8sContainer(
        projectID: String, // The identifier of the GCP project associated with this resource, such as "my-project".
        location: String, // The physical location of the cluster that contains the container.
        clusterName: String, // The name of the cluster that the container is running in.
        namespaceName: String, // The name of the namespace that the container is running in.
        podName: String, // The name of the pod that the container is running in.
        containerName: String // The name of the container.
    )
    case cloudRunJob(
        jobName: String, // The name of the Cloud Run job being run.
        executionName: String, // The name of the Cloud Run execution being run.
        taskIndex: UInt16, // For each task, this will be set to a unique value between 0 and the number of tasks minus 1.
        taskAttempt: UInt32, // The number of times this task has been retried. Starts at 0 for the first attempt; increments by 1 for every successive retry, up to the maximum retries value.
        taskCount: UInt16 // The number of tasks defined in the --tasks parameter.
    )
    case cloudRunRevision(
        serviceName: String, // The name of the Cloud Run service being run.
        revisionName: String, // The name of the Cloud Run revision being run.
        configurationName: String // The name of the Cloud Run configuration that created the revision.
    )

    public static var current: Environment {
        if _current == nil {
            _current = resolveCurrent()
            if _current == nil {
                fatalError("Could not automatically resolve environment")
            }
        }

        return _current!
    }

    // MARK: - Convenience

    private struct ServiceAccount: Decodable {

        let project_id: String
    }

    private var _projectID: String {
        switch self {
        case .k8sContainer(let projectID, _, _, _, _, _):
            return projectID
#if DEBUG
        case .localDevelopment:
            return ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] ?? "dev"
#endif
        default:
            break
        }
        if
            let path = ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"],
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let serviceAccount = try? JSONDecoder().decode(ServiceAccount.self, from: data)
        {
            return serviceAccount.project_id
        }
        return ProcessInfo.processInfo.environment["GCP_PROJECT_ID"]!
    }

    public var projectID: String {
        if __projectID == nil {
            __projectID = _projectID
        }
        return __projectID!
    }

    public var locationID: String {
        switch self {
#if DEBUG
        case .localDevelopment:
            return "dev"
#endif
        default:
            break
        }
        return ProcessInfo.processInfo.environment["GCP_LOCATION"]!
    }

    public var serviceName: String {
        switch self {
        case .k8sContainer(_, _, _, _, _, let containerName):
            return containerName
        case .cloudRunJob(let jobName, _, _, _, _):
            return jobName
        case .cloudRunRevision(let serviceName, _, _):
            return serviceName
#if DEBUG
        case .localDevelopment:
            return "dev"
#endif
        }
    }

    public var instanceID: String? {
        switch self {
        case .k8sContainer(_, _, _, _, let podName, _):
            return podName
#if DEBUG
        case .localDevelopment:
            return "0"
#endif
        default:
            break
        }
        return ProcessInfo.processInfo.environment["INSTANCE_ID"]
    }

    public var version: String? {
        switch self {
        case .cloudRunRevision(_, let revisionName, _):
            return revisionName
#if DEBUG
        case .localDevelopment:
            return "0"
#endif
        default:
            break
        }
        return ProcessInfo.processInfo.environment["APP_VERSION"]
    }
}
