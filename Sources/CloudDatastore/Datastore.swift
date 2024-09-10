import Foundation
import GRPC
import NIO
import CloudCore
import CloudTrace

#if DEBUG
// Only used for testing. See Datastore.bootstrapForTesting(eventLoopGroup:).
private nonisolated(unsafe) var emulatorStartTask: Task<UnsafeSendableProcess, Error>?
private nonisolated(unsafe) var emulatorTeardownTimer: Timer?

struct UnsafeSendableProcess: @unchecked Sendable {

    let value: Process
}
#endif

public actor Datastore: Dependency {

    public static var shared = Datastore()

    private var _client: Google_Datastore_V1_DatastoreAsyncClient?

    func client(context: Context) async throws -> Google_Datastore_V1_DatastoreAsyncClient {
        if _client == nil {
            try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
        }
        var _client = _client!
        try await _client.ensureAuthentication(authorization: authorization, context: context, traceContext: "datastore")
        self._client = _client
        return _client
    }

    var authorization: Authorization?

    // MARK: - Bootstrap

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
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

    func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        authorization = try Authorization(scopes: [
            "https://www.googleapis.com/auth/datastore",
        ], eventLoopGroup: eventLoopGroup)

        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "datastore.googleapis.com", port: 443)

        self._client = .init(channel: channel)
        try await authorization?.warmup()
    }

    func bootstraForEmulator(host: String, port: Int, eventLoopGroup: EventLoopGroup) {
        let channel = ClientConnection
            .insecure(group: eventLoopGroup)
            .connect(host: host, port: port)

        self._client = .init(channel: channel)
    }

#if DEBUG

    public func bootstrapForTesting(eventLoopGroup: EventLoopGroup) async throws {
        emulatorTeardownTimer?.invalidate()
        emulatorTeardownTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            print("\(#function): Stopping datastore emulator.")

            emulatorTeardownTimer = nil
            emulatorStartTask = nil
            Task {
                guard let process = try await emulatorStartTask?.value.value else {
                    return
                }
                process.interrupt()
                process.waitUntilExit()
            }
        }

        if let existing = emulatorStartTask {
            _ = try await existing.value
            return
        }

        let task: Task<UnsafeSendableProcess, Error> = Task {
            let port = 7245

            print("\(#function): Starting datastore emulator at port \(port).")

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

            return .init(value: process)
        }
        emulatorStartTask = task
        _ = try await task.value
    }
#endif

    // MARK: - Termination

    public func shutdown() async throws {
        try await authorization?.shutdown()
    }
}
