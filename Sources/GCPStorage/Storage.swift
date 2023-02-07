import Foundation
import GCPCore
import NIO
import AsyncHTTPClient
import NIOHTTP1
import GCPTrace

public struct Storage: Dependency {

    static var authorization: Authorization!

    private static var _client: HTTPClient?

    static var client: HTTPClient {
        get {
            guard let _client = _client else {
                fatalError("Must call Storage.bootstrap(eventLoopGroup:) first")
            }
            return _client
        }
        set { _client = newValue }
    }

    // MARK: - Bootstrap

    public static func bootstrap(eventLoopGroup: EventLoopGroup) async throws {
        authorization =  try Authorization(scopes: [
            "https://www.googleapis.com/auth/devstorage.read_write",
        ], eventLoopGroup: eventLoopGroup)

        _client = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        try await authorization.warmup()
    }

    // MARK: - Termination

    public static func shutdown() async throws {
        try await authorization?.shutdown()
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
        var urlComponents = URLComponents(string: "https://storage.googleapis.com/storage/v1" + path)!
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
