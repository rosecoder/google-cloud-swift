import Foundation
import CloudCore
import AsyncHTTPClient
import NIOHTTP1
import Crypto
import Tracing

extension Storage {

    /// Method of signing. See https://cloud.google.com/storage/docs/access-control/signed-urls#signing-iam
    public enum SigningMethod: Sendable {

        /// Using [signBlob](https://cloud.google.com/iam/docs/reference/credentials/rest/v1/projects.serviceAccounts/signBlob)-method. Requires the role `roles/iam.serviceAccountTokenCreator` for the current service accont.
        case iam
    }

    public enum SignError: Error {
        case expirationTooLong
        case signingFailed(HTTPResponseStatus, body: String)
        case unexpectedMetdataStatus(HTTPResponseStatus)
    }

    /// The maxiumum expiration duration for a signed URL.
    public static let signedURLMaximumExpirationDuration: TimeInterval = 3600 * 12 // if this changes, make sure to check the bounds of types below

    public func generateSignedURL(
        for action: SignedAction,
        expiration: TimeInterval,
        object: Object,
        in bucket: Bucket
    ) async throws -> String {
        guard expiration <= Self.signedURLMaximumExpirationDuration else {
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
            httpMethod = "PUT"
        }
        return try await generateSignedURL(
            bucket: bucket,
            httpMethod: httpMethod,
            host: bucket.name.lowercased() + ".storage.googleapis.com",
            path: "/" + object.path,
            queryParameters: [:],
            headers: [:],
            expiration: .init(expiration)
        )
    }

    /// https://cloud.google.com/storage/docs/access-control/signing-urls-manually
    private func generateSignedURL(
        bucket: Bucket,
        httpMethod: String,
        host: String,
        path: String,
        queryParameters: [String: String],
        headers: [String: String],
        expiration: UInt32
    ) async throws -> String {
        try await withSpan("storage-sign", ofKind: .client) { span in
            span.attributes["storage/bucket"] = bucket.name

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
            let serviceAccount = try await ServiceAccountCoordinator.shared.current
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

    private func sign(payload: Data, serviceAccount: ServiceAccount) async throws -> Data {
        switch signingMethod {
        case .iam:
            return try await signUsingIAM(payload: payload, serviceAccount: serviceAccount)
        }
    }

    private func signUsingIAM(payload: Data, serviceAccount: ServiceAccount) async throws -> Data {

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
}
