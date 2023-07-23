import Foundation
import Logging
import AsyncHTTPClient
import NIOHTTP1

private var currentTask: Task<ServiceAccount, Error>?
private var _client: HTTPClient?

private var client: HTTPClient {
    if _client == nil {
        _client = HTTPClient(eventLoopGroupProvider: .shared(_unsafeInitializedEventLoopGroup))
    }
    return _client!
}

public struct ServiceAccount: Decodable {

    public let email: String

    public init(email: String) {
        self.email = email
    }

    enum CodingKeys: String, CodingKey {
        case email = "client_email"
    }

    // MARK: - Resolve

    private static let logger = Logger(label: "core.serviceAccount")

    public enum ServiceAccountError: Error {
        case unexpectedMetdataStatus(HTTPResponseStatus, body: String)
    }

    public static var custom: ServiceAccount?

    /// The current service account. Automatically resolved depending on environment.
    public static var current: ServiceAccount {
        get async throws {
            if let custom {
                logger.debug("Using custom service account.")
                return custom
            }
            if let currentTask {
                do {
                    return try await currentTask.value
                } catch {
                    logger.warning("Error re-using existing task for resolving service account: \(error)")
                }
            }
            let task = Task {
                if let serviceAccount = try usingFile() {
                    logger.debug("Using service account from file.")
                    return serviceAccount
                }
                logger.debug("Using service account from metadata server.")
                return try await usingMetadata()
            }
            currentTask = task
            return try await task.value
        }
    }

    /// Resolves service account using a file.
    private static func usingFile() throws -> ServiceAccount? {
        guard let credentialsPath = ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"] else {
            return nil
        }

        let credentialsURL = URL(fileURLWithPath: credentialsPath)
        let data = try Data(contentsOf: credentialsURL)
        return try JSONDecoder().decode(ServiceAccount.self, from: data)
    }

    /// Resolves service account using the metadata server.
    private static func usingMetadata() async throws -> ServiceAccount {
        var request = HTTPClientRequest(url: "http://metadata/computeMetadata/v1/instance/service-accounts/default/email")
        request.method = .GET
        request.headers.add(name: "Metadata-Flavor", value: "Google")

        let response = try await client.execute(request, timeout: .seconds(10))
        let body = try await response.body.collect(upTo: 1024 * 10) // 10 KB

        switch response.status {
        case .ok:
            return .init(email: String(buffer: body))
        default:
            throw ServiceAccountError.unexpectedMetdataStatus(response.status, body: String(buffer: body))
        }
    }
}
