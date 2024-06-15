import Foundation
import AsyncHTTPClient
import CloudCore

extension ErrorReporting {

    struct UnparsableRemoteError: Error {}

    public static func report(
        date: Date,
        message: String,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) async throws {
        let request = try await self.request(date: date, message: message, source: source, file: file, function: function, line: line)
        let response = try await shared.client.execute(request, timeout: .seconds(15))
        try await handle(response: response)
    }

    // MARK: - Request

    private static func request(
        date: Date,
        message: String,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) async throws -> HTTPClientRequest {
        let environment = await Environment.current
        let projectID = await environment.projectID
        var request = HTTPClientRequest(
            url: "https://clouderrorreporting.googleapis.com/v1beta1/projects/\(projectID)/events:report" // TODO: Encode project id
        )
        request.method = .POST

        // Authorization
        let accessToken = try await shared.authorization.accessToken()
        request.headers.add(name: "Authorization", value: "Bearer " + accessToken)

        // Body
        let body = RequestBody(
            eventTime: RequestBody.dateFormatter.string(from: date),
            serviceContext: .init(
                service: environment.serviceName,
                version: environment.version ?? "0"
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

    private static func handle(response: HTTPClientResponse) async throws {
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
