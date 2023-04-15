import Foundation

extension Environment {

    static func resolveCurrent() -> Environment? {
        if let resolved = kubernetes() {
            return resolved
        }
        if let resolved = cloudRunJob() {
            return resolved
        }
        if let resolved = cloudRunRevision() {
            return resolved
        }
#if DEBUG
        return .localDevelopment
#else
        return nil
#endif
    }

    private static func kubernetes() -> Environment? {
        guard
            let projectID = ProcessInfo.processInfo.environment["GCP_PROJECT_ID"],
            let location = ProcessInfo.processInfo.environment["GCP_LOCATION"],
            let clusterName = ProcessInfo.processInfo.environment["KUBERNETES_CLUSTER"],
            let namespaceName = ProcessInfo.processInfo.environment["KUBERNETES_NAMESPACE"],
            let podName = ProcessInfo.processInfo.environment["KUBERNETES_POD_NAME"],
            let containerName = ProcessInfo.processInfo.environment["KUBERNETES_CONTAINER_NAME"]

            else { return nil }

        return .k8sContainer(
            projectID: projectID,
            location: location,
            clusterName: clusterName,
            namespaceName: namespaceName,
            podName: podName,
            containerName: containerName
        )
    }

    private static func cloudRunJob() -> Environment? {
        guard
            let jobName = ProcessInfo.processInfo.environment["CLOUD_RUN_JOB"],
            let executionName = ProcessInfo.processInfo.environment["CLOUD_RUN_EXECUTION"],
            let taskIndexString = ProcessInfo.processInfo.environment["CLOUD_RUN_TASK_INDEX"],
            let taskAttemptString = ProcessInfo.processInfo.environment["CLOUD_RUN_TASK_ATTEMPT"],
            let taskCountString = ProcessInfo.processInfo.environment["CLOUD_RUN_TASK_COUNT"],
            let taskIndex = UInt16(taskIndexString),
            let taskAttempt = UInt32(taskAttemptString),
            let taskCount = UInt16(taskCountString)

            else { return nil }

        return .cloudRunJob(
            jobName: jobName,
            executionName: executionName,
            taskIndex: taskIndex,
            taskAttempt: taskAttempt,
            taskCount: taskCount
        )
    }

    private static func cloudRunRevision() -> Environment? {
        guard
            let serviceName = ProcessInfo.processInfo.environment["K_SERVICE"],
            let revisionName = ProcessInfo.processInfo.environment["K_REVISION"],
            let configurationName = ProcessInfo.processInfo.environment["K_CONFIGURATION"]

            else { return nil }

        return .cloudRunRevision(
            serviceName: serviceName,
            revisionName: revisionName,
            configurationName: configurationName
        )
    }
}
