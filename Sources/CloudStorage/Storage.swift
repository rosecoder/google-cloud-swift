import Foundation
import CloudCore
import NIO
import AsyncHTTPClient
import NIOHTTP1
import GoogleCloudAuth
import ServiceLifecycle
import Synchronization

public final class Storage: Service, StorageProtocol {

    let authorization: Authorization
    let client: HTTPClient

    private let _signingMethod = Mutex<SigningMethod>(.iam)

    public var signingMethod: SigningMethod {
        get { _signingMethod.withLock { $0 } }
        set { _signingMethod.withLock { $0 = newValue } }
    }

    public init() {
        self.authorization = Authorization(scopes: [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/iam",
            "https://www.googleapis.com/auth/devstorage.read_write",
        ], eventLoopGroup: .singletonMultiThreadedEventLoopGroup)

        self.client = HTTPClient(eventLoopGroupProvider: .shared(.singletonMultiThreadedEventLoopGroup))
    }

#if DEBUG
    let isUsingLocalStorage = true
#endif

    public func run() async throws {
        await cancelWhenGracefulShutdown {
            try? await Task.sleepUntilCancelled()
        }

        try await client.shutdown()
        try await authorization.shutdown()
    }

    // MARK: - Requests

    public struct UnparsableRemoteError: Error {

        public let statusCode: UInt
        public let description: String
    }

    public struct NotFoundError: Error {}

    public struct RemoteError: Error, Decodable {

        public let code: Int
        public let message: String

       // MARK: - Decodable

       private enum RootCodingKeys: String, CodingKey {
           case error = "error"
       }

       private enum CodingKeys: String, CodingKey {
           case code = "code"
           case message = "message"
       }

        public init(from decoder: Decoder) throws {
           let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
           let container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)

           self.code = try container.decode(Int.self, forKey: .code)
           self.message = try container.decode(String.self, forKey: .message)
       }
   }

    func execute(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        headers: HTTPHeaders? = nil,
        body: HTTPClientRequest.Body? = nil
    ) async throws {
        var urlComponents = URLComponents(string: "https://storage.googleapis.com" + path)!
        urlComponents.queryItems = queryItems

        var request = HTTPClientRequest(url: urlComponents.string!)
        request.method = method
        if let headers {
            request.headers = headers
        }
        if let body {
            request.body = body
        }

        // Authorization
        let accessToken = try await authorization.accessToken()
        request.headers.add(name: "Authorization", value: "Bearer " + accessToken)

        // Perform
        let response = try await client.execute(request, timeout: .seconds(30))

        switch response.status {
        case .ok, .created, .accepted, .noContent:
            return
        case .notFound:
            throw NotFoundError()
        default:
            let body = try await response.body.collect(upTo: 1024 * 10) // 10 KB

            let remoteError: RemoteError
            do {
                remoteError = try JSONDecoder().decode(RemoteError.self, from: body)
            } catch {
                throw UnparsableRemoteError(statusCode: response.status.code, description: String(buffer: body))
            }
            throw remoteError
        }
    }
}
