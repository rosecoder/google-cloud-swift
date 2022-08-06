import Foundation
import AsyncHTTPClient
import NIO

extension HTTPClient {

    public func execute(
        _ request: HTTPClientRequest,
        timeout: TimeAmount,
        context: Context
    ) async throws -> HTTPClientResponse {
        var span = context.trace?.span(
            named: URLComponents(string: request.url)?.host ?? request.url,
            kind: .client,
            attributes: [
                "/http/url": request.url,
                "/http/method": request.method.rawValue,
            ]
        )
        do {
            let response = try await execute(request, timeout: timeout)
            var additionalAttributes: [String: AttributableValue] = [
                "/http/status_code": response.status.code,
            ]
            if
                let rawContentLength = response.headers.first(name: "Content-Length"),
                let contentLength = UInt(rawContentLength)
            {
                additionalAttributes["/http/response/size"] = contentLength
            }
            span?.end(statusCode: .ok, additionalAttributes: additionalAttributes)
            return response
        } catch {
            span?.end(error: error)
            throw error
        }
    }
}
