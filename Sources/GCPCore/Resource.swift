import Foundation

private var autoResolved: Resource?

/// Defined: https://cloud.google.com/monitoring/api/resources
public enum Resource {
    case k8sContainer(
        projectID: String, // The identifier of the GCP project associated with this resource, such as "my-project".
        location: String, // The physical location of the cluster that contains the container.
        clusterName: String, // The name of the cluster that the container is running in.
        namespaceName: String, // The name of the namespace that the container is running in.
        podName: String, // The name of the pod that the container is running in.
        containerName: String // The name of the container.
    )

    public static var autoResolve: Resource {
        if autoResolved == nil {
            guard
                let projectID = ProcessInfo.processInfo.environment["GCP_PROJECT_ID"],
                let location = ProcessInfo.processInfo.environment["GCP_LOCATION"],
                let clusterName = ProcessInfo.processInfo.environment["KUBERNETES_CLUSTER"],
                let namespaceName = ProcessInfo.processInfo.environment["KUBERNETES_NAMESPACE"],
                let podName = ProcessInfo.processInfo.environment["KUBERNETES_POD_NAME"],
                let containerName = ProcessInfo.processInfo.environment["KUBERNETES_CONTAINER_NAME"]

                else { fatalError("Could not automatically resolve resource") }

            autoResolved = .k8sContainer(projectID: projectID, location: location, clusterName: clusterName, namespaceName: namespaceName, podName: podName, containerName: containerName)
        }

        return autoResolved!
    }

    public var rawValue: String {
        switch self {
        case .k8sContainer: return "k8s_container"
        }
    }

    public static var version: String? {
        ProcessInfo.processInfo.environment["APP_VERSION"]
    }
}
