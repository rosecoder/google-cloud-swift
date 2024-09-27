import Foundation
import CloudCore
import NIO
import AsyncHTTPClient
import NIOHTTP1
import CloudTrace
import GoogleCloudAuth

public actor Storage: Dependency {

    public static let shared = Storage()

    var _authorization: Authorization?

    var authorization: Authorization {
        get throws {
            if _authorization == nil {
                _authorization = Authorization(scopes: [
                    "https://www.googleapis.com/auth/cloud-platform",
                    "https://www.googleapis.com/auth/iam",
                    "https://www.googleapis.com/auth/devstorage.read_write",
                ], eventLoopGroup: _unsafeInitializedEventLoopGroup)
            }
            return _authorization!
        }
    }

    private var _client: HTTPClient?

    func client() async throws -> HTTPClient {
        if _client == nil {
            try await self.bootstrap(eventLoopGroup: _unsafeInitializedEventLoopGroup)
        }
        return _client!
    }

#if DEBUG
    static var isUsingLocalStorage = false
#endif

    // MARK: - Bootstrap

    public func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
#if DEBUG
        if ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"]?.isEmpty == false {
            try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
        } else {
            try await bootstrapForDebug()
        }
#else
        try await bootstrapForProduction(eventLoopGroup: eventLoopGroup)
#endif
    }

    func bootstrapForProduction(eventLoopGroup: EventLoopGroup) async throws {
        _client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    }

#if DEBUG
    func bootstrapForDebug() async throws {
        Self.isUsingLocalStorage = true
    }
#endif

    // MARK: - Termination

    public func shutdown() async throws {
        try await _authorization?.shutdown()
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

    static func execute(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        headers: HTTPHeaders? = nil,
        body: HTTPClientRequest.Body? = nil,
        context: Context
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
        let accessToken = try await shared.authorization.accessToken()
        request.headers.add(name: "Authorization", value: "Bearer " + accessToken)

        // Perform
        let response = try await shared.client().execute(request, timeout: .seconds(30))

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
