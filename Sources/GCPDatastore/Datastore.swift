import Foundation
import GRPC
import NIO
import OAuth2
import GCPCore

#if DEBUG
// Only used for testing. See Datastore.bootstrapForTesting(eventLoopGroup:).
private var emulatorTask: Task<Void, Error>?
#endif

public struct Datastore: Dependency {

    private static var _client: Google_Datastore_V1_DatastoreAsyncClient?

    static var client: Google_Datastore_V1_DatastoreAsyncClient {
        get {
            guard let _client = _client else {
                fatalError("Must call Datastore.bootstrap(eventLoopGroup:) first")
            }

            return _client
        }
        set {
            _client = newValue
        }
    }

    public static var defaultProjectID: String = ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] ?? ""

    static var authorization = Authorization(scopes: [
        "https://www.googleapis.com/auth/datastore",
    ])

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        if let host = ProcessInfo.processInfo.environment["DATASTORE_EMULATOR_HOST"] {
            let components = host.components(separatedBy: ":")
            bootstraForEmulator(
                host: components[0],
                port: Int(components[1])!,
                eventLoopGroup: eventLoopGroup
            )
        } else {
            try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
        }
    }

    static func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "datastore.googleapis.com", port: 443)

        self._client = .init(channel: channel)
    }

    static func bootstraForEmulator(host: String, port: Int, eventLoopGroup: EventLoopGroup) {
        let channel = ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: host, port: port)

        self._client = .init(channel: channel)
    }

#if DEBUG

    public static func bootstrapForTesting(eventLoopGroup: EventLoopGroup) async throws {
        defaultProjectID = "test"

        if let existing = emulatorTask {
            try await existing.value
            return
        }

        let task = Task {
            let port = 7245

            // Start server
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/Applications/google-cloud-sdk/bin/gcloud")
            process.arguments = [
                "beta",
                "emulators",
                "datastore",
                "start",
                "--consistency=1.0",
                "--no-store-on-disk",
                "--host-port=localhost:\(port)",
            ]

            let outputPipe = Pipe()
            process.standardError = outputPipe

            try process.run()

            // Wait for server to start or fail to bind (already started)
            let unableToBindKeywords: [String] = [
                "Failed to bind",
                "BindException",
            ]

            var buffer = ""
            while
                !buffer.contains("Dev App Server is now running.") &&
                !unableToBindKeywords.contains(where: { buffer.contains($0) })
            {
                if
                    let outputData = try outputPipe.fileHandleForReading .read(upToCount: 10),
                    let output = String(data: outputData, encoding: .utf8)
                {
                    buffer += output
                }
            }

            // Was already running?
            if unableToBindKeywords.contains(where: { buffer.contains($0) }) {
                print("\(#function): Datastore emulator already running.")
                
                process.interrupt()
                process.waitUntilExit()
            } else {
                print("\(#function): Datastore emulator started.")
            }

            // Connect
            bootstraForEmulator(host: "localhost", port: port, eventLoopGroup: eventLoopGroup)
        }
        emulatorTask = task
        try await task.value
    }
#endif
}
