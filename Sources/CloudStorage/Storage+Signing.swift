import Foundation
import CloudTrace
import AsyncHTTPClient
import NIOHTTP1
import Crypto
import Logging

extension Storage {

    public static var signingMethod: SigningMethod = .iam
    public static var signingServiceAccountEmail: String?

    /// Method of signing. See https://cloud.google.com/storage/docs/access-control/signed-urls#signing-iam
    public enum SigningMethod {

        /// Using [signBlob](https://cloud.google.com/iam/docs/reference/credentials/rest/v1/projects.serviceAccounts/signBlob)-method. Requires the role `roles/iam.serviceAccountTokenCreator` for the current service accont.
        case iam
    }

    public enum SignedAction {
        case reading
        case writing
    }

    public enum SignError: Error {
        case expirationTooLong
        case signingFailed(HTTPResponseStatus, body: String)
        case unexpectedMetdataStatus(HTTPResponseStatus)
    }

    /// The maxiumum expiration duration for a signed URL.
    public static let signedURLMaximumExpirationDuration: TimeInterval = 3600 * 12 // if this changes, make sure to check the bounds of types below

    public static func generateSignedURL(
        for action: SignedAction,
        expiration: TimeInterval = signedURLMaximumExpirationDuration,
        object: Object,
        in bucket: Bucket,
        context: Context
    ) async throws -> String {
        guard expiration <= signedURLMaximumExpirationDuration else {
            throw SignError.expirationTooLong
        }

#if DEBUG
        guard !isUsingLocalStorage else {
            return object.localStorageURL(in: bucket).absoluteString
        }
#endif

        let httpMethod: String
        switch action {
        case .reading:
            httpMethod = "GET"
        case .writing:
            httpMethod = "POST"
        }
        return try await generateSignedURL(
            bucket: bucket,
            httpMethod: httpMethod,
            host: bucket.name.lowercased() + ".storage.googleapis.com",
            path: "/" + object.path,
            queryParameters: [:],
            headers: [:],
            expiration: .init(expiration),
            context: context
        )
    }

    /// https://cloud.google.com/storage/docs/access-control/signing-urls-manually
    private static func generateSignedURL(
        bucket: Bucket,
        httpMethod: String,
        host: String,
        path: String,
        queryParameters: [String: String],
        headers: [String: String],
        expiration: UInt32,
        context: Context
    ) async throws -> String {
        try await context.trace.recordSpan(named: "storage-sign", kind: .client, attributes: [
            "storage/bucket": bucket.name,
        ]) { span in

            // Dates
            let now = Date()

            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            let requestTimestamp = dateFormatter.string(from: now)

            dateFormatter.dateFormat = "yyyyMMdd"
            let datestamp = dateFormatter.string(from: now)

            // Service account
            let serviceAccount = try await serviceAccount.value
            let credentialScope = datestamp + "/auto/storage/goog4_request"

            // Headers
            var headers = headers
            headers["host"] = host
            for (key, value) in headers {
                precondition(key == key.lowercased(), "Header must be lowercased")
                precondition(value == value.lowercased(), "Header value must be lowercased")
            }
            let headerKeys = headers.keys.sorted()
            let canonicalHeaders = headerKeys.indices
                .map { headerKeys[$0] + ":" + headers[headerKeys[$0]]!.lowercased() }
                .joined(separator: "\n")
            let signedHeaders = headerKeys.joined(separator: ";")

            // Query parameters
            var queryParameters = queryParameters
            queryParameters["X-Goog-Algorithm"] = "GOOG4-RSA-SHA256"
            queryParameters["X-Goog-Credential"] = serviceAccount.email + "/" + credentialScope
            queryParameters["X-Goog-Date"] = requestTimestamp
            queryParameters["X-Goog-Expires"] = String(expiration)
            queryParameters["X-Goog-SignedHeaders"] = signedHeaders

            let canonicalQueryString = queryParameters.keys
                .sorted()
                .map {
                    $0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! +
                    "=" +
                    queryParameters[$0]!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                }
                .joined(separator: "&")

            // Create canonical request
            let canonicalRequest = [
                httpMethod,
                path,
                canonicalQueryString,
                canonicalHeaders,
                "",
                signedHeaders,
                "UNSIGNED-PAYLOAD",
            ].joined(separator: "\n")

            let canonicalRequestHash = SHA256.hash(data: Data(canonicalRequest.utf8))
                .compactMap { String(format: "%02x", $0) }
                .joined()

            // Signing itself
            let stringToSign = [
                "GOOG4-RSA-SHA256",
                requestTimestamp,
                credentialScope,
                canonicalRequestHash,
            ].joined(separator: "\n")

            let signature = try await sign(payload: Data(stringToSign.utf8), serviceAccount: serviceAccount)
                .map { String(format: "%02x", $0) }
                .joined()

            // Create URL
            return "https://" + host + path + "?" + canonicalQueryString + "&X-Goog-Signature=" + signature
        }
    }

    private static func sign(payload: Data, serviceAccount: ServiceAccount) async throws -> Data {
        switch signingMethod {
        case .iam:
            return try await signUsingIAM(payload: payload, serviceAccount: serviceAccount)
        }
    }

    private static func signUsingIAM(payload: Data, serviceAccount: ServiceAccount) async throws -> Data {

        struct Request: Encodable {
            let delegates: [String]
            let payload: Data
        }
        struct Response: Decodable {
            let signedBlob: Data
        }

        let name = "projects/-/serviceAccounts/" + serviceAccount.email

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        let requestBody = try encoder.encodeAsByteBuffer(Request(
            delegates: [name],
            payload: payload
        ), allocator: .init())

        var request = HTTPClientRequest(url: "https://iamcredentials.googleapis.com/v1/\(name):signBlob")
        request.method = .POST
        request.headers.add(name: "Authorization", value: "Bearer " + (try await authorization.accessToken()))
        request.body = .bytes(requestBody)

        let response = try await client.execute(request, timeout: .seconds(60))
        let responseBody = try await response.body.collect(upTo: 1024 * 10) // 10 KB
        guard response.status == .ok else {
            throw SignError.signingFailed(response.status, body: String(buffer: responseBody))
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        let result = try decoder.decode(Response.self, from: responseBody)
        return result.signedBlob
    }

    // MARK: - Service Account

    private static let serviceAccountLogger = Logger(label: "storage.serviceAccount")

    private struct ServiceAccount: Decodable {

        let email: String

        enum CodingKeys: String, CodingKey {
            case email = "client_email"
        }
    }

    private static var _serviceAccount: Task<ServiceAccount, Error>?
    private static var serviceAccount: Task<ServiceAccount, Error> {
        if _serviceAccount == nil {
            _serviceAccount = Task {
                if let email = signingServiceAccountEmail {
                    serviceAccountLogger.debug("Using service account given for signing.")
                    return .init(email: email)
                }
                if let serviceAccount = try serviceAccountUsingFile {
                    serviceAccountLogger.debug("Using service account from file.")
                    return serviceAccount
                }
                serviceAccountLogger.debug("Using service account from metadata server.")
                return try await serviceAccountUsingMetadata
            }
        }
        return _serviceAccount!
    }

    private static var serviceAccountUsingFile: ServiceAccount? {
        get throws {
            guard let credentialsPath = ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"] else {
                return nil
            }

            let credentialsURL = URL(fileURLWithPath: credentialsPath)
            let data = try Data(contentsOf: credentialsURL)
            return try JSONDecoder().decode(ServiceAccount.self, from: data)
        }
    }

    private static var serviceAccountUsingMetadata: ServiceAccount {
        get async throws {
            var request = HTTPClientRequest(url: "http://metadata/computeMetadata/v1/instance/service-accounts/default/email")
            request.method = .GET
            request.headers.add(name: "Metadata-Flavor", value: "Google")

            let response = try await client.execute(request, timeout: .seconds(10))

            switch response.status {
            case .ok:
                let body = try await response.body.collect(upTo: 1024 * 10) // 10 KB
                return .init(email: String(buffer: body))
            default:
                throw SignError.unexpectedMetdataStatus(response.status)
            }
        }
    }
}
