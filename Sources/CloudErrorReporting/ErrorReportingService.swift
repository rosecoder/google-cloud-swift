import Foundation
import ServiceLifecycle
import ServiceContextModule
import GoogleCloudServiceContext
import GoogleCloudAuth
import AsyncHTTPClient

public final class ErrorReportingService: Service {

    let authorization: Authorization
    let client: HTTPClient

    public init() {
        self.authorization = Authorization(scopes: [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/stackdriver-integration",
        ], eventLoopGroup: .singletonMultiThreadedEventLoopGroup)

        self.client = HTTPClient(eventLoopGroupProvider: .shared(.singletonMultiThreadedEventLoopGroup))
    }

    public func run() async throws {
        let foreverTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(.infinity))
            }
        }
        await withGracefulShutdownHandler {
            await foreverTask.value
        } onGracefulShutdown: {
            foreverTask.cancel()
        }

        try await client.shutdown()
        try await authorization.shutdown()
    }

    struct UnparsableRemoteError: Error {}

    public func report(
        date: Date,
        message: String,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        let request = try await self.request(date: date, message: message, source: source, file: file, function: function, line: line)
        let response = try await client.execute(request, timeout: .seconds(15))
        try await handle(response: response)
    }

    // MARK: - Request

    private enum EnvironmentError: Error {
        case missingProjectID
    }

    private func request(
        date: Date,
        message: String,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) async throws -> HTTPClientRequest {
        let serviceContext = ServiceContext.current ?? .topLevel
        guard let projectID = serviceContext.projectID else {
            throw EnvironmentError.missingProjectID
        }
        var request = HTTPClientRequest(
            url: "https://clouderrorreporting.googleapis.com/v1beta1/projects/\(projectID)/events:report" // TODO: Encode project id
        )
        request.method = .POST

        // Authorization
        let accessToken = try await authorization.accessToken()
        request.headers.add(name: "Authorization", value: "Bearer " + accessToken)

        // Body
        let body = RequestBody(
            eventTime: RequestBody.dateFormatter.string(from: date),
            serviceContext: .init(
                service: serviceContext.serviceName ?? "swift",
                version: serviceContext.serviceVersion ?? "0"
            ),
            message: "\(source): \(message)",
            context: .init(
                httpRequest: nil,
                user: nil,
                reportLocation: .init(
                    filePath: file,
                    lineNumber: line,
                    functionName: function
                ),
                sourceReferences: nil
            )
        )
        let data = try JSONEncoder().encode(body)
        request.body = .bytes(data)

        return request
    }

    // MARK: - Response

    private func handle(response: HTTPClientResponse) async throws {
        switch response.status {
        case .ok, .created:
            break // Success! No need to check response body or anything else.
        default:
            let body = try await response.body.collect(upTo: 1024) // 1 KB

            let remoteError: RemoteError
            do {
                remoteError = try JSONDecoder().decode(RemoteError.self, from: body)
            } catch {
                throw UnparsableRemoteError()
            }
            throw remoteError
        }
    }
}

