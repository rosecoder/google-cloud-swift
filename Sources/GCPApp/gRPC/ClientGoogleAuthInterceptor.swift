import Foundation
import GRPC
import NIO
import AsyncHTTPClient
import GCPCore

public final class ClientGoogleAuthInterceptor<Request, Response, DependencyType: GRPCDependency>: GRPC.ClientInterceptor<Request, Response> {

    private let targetAudience: String

    public init?(_ dependencyType: DependencyType.Type) {
        guard let address = ProcessInfo.processInfo.environment[dependencyType.serviceEnvironmentName] else {
            return nil
        }

        let (scheme, host, _) = try! address.parsedAddressComponents() // safe to force unwrap because address has already been parsed in bootstrap (it's not pretty though)
        self.targetAudience = scheme + "://" + host + "/"

        super.init()
    }

    public override func send(_ part: GRPCClientRequestPart<Request>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Request, Response>) {
        guard context.type == .unary else {
            context.send(part, promise: promise)
            return
        }

        switch part {
        case .metadata(var headers):
            idToken(targetAudience: targetAudience, eventLoop: context.eventLoop)
                .whenComplete { result in
                    switch result {
                    case .failure(let error):
                        context.errorCaught(error)
                    case .success((let accessToken, _)):
                        headers.replaceOrAdd(name: "Authorization", value: "Bearer " + accessToken)
                        context.send(.metadata(headers), promise: promise)
                    }
                }
        default:
            context.send(part, promise: promise)
        }
    }
}

private var activeIDTokenFutures = [String: EventLoopFuture<(String, Date)>]()
private var client: HTTPClient?

private struct IDTokenPayload: Decodable {

    let exp: TimeInterval
}

private enum IDTokenError: Error {
    case noData
    case notJWT(String)
    case invalidJWTPayload(String)
}

private func idToken(targetAudience: String, eventLoop: EventLoop) -> EventLoopFuture<(String, Date)> {
    if let future = activeIDTokenFutures[targetAudience] {
        return future.flatMap { (idToken, expiration) in
            if expiration < Date() {
                return requestIDToken(targetAudience: targetAudience, eventLoop: eventLoop)
            }
            return eventLoop.makeSucceededFuture((idToken, expiration))
        }
    }

    return requestIDToken(targetAudience: targetAudience, eventLoop: eventLoop)
}

private func requestIDToken(targetAudience: String, eventLoop: EventLoop) -> EventLoopFuture<(String, Date)> {
    if client == nil {
        client = HTTPClient(eventLoopGroupProvider: .shared(_unsafeInitializedEventLoopGroup))
    }

    var urlComponents = URLComponents(string: "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity")!
    urlComponents.queryItems = [
        .init(name: "audience", value: targetAudience),
    ]

    let request = try! HTTPClient.Request(url: urlComponents.string!, headers: [
        "Metadata-Flavor": "Google",
    ])

    let future = client!.execute(request: request, eventLoop: .delegate(on: eventLoop))
        .flatMapThrowing { response in
            guard let body = response.body else {
                throw IDTokenError.noData
            }

            let idToken = String(buffer: body)
            let jwtComponents = idToken.components(separatedBy: ".")
            guard jwtComponents.count >= 3 else {
                throw IDTokenError.notJWT(idToken)
            }
            var payloadBase64String = jwtComponents[1]

            // Add missing padding
            let remainder = payloadBase64String.count % 4
            if remainder > 0 {
                payloadBase64String = payloadBase64String.padding(toLength: payloadBase64String.count + 4 - remainder, withPad: "=", startingAt: 0)
            }

            guard let payloadData = Data(base64Encoded: payloadBase64String) else {
                throw IDTokenError.invalidJWTPayload(payloadBase64String)
            }

            let payload = try JSONDecoder().decode(IDTokenPayload.self, from: payloadData)
            let expiration = Date(timeIntervalSince1970: payload.exp)

            return (idToken, expiration)
        }
    activeIDTokenFutures[targetAudience] = future // TODO: lock needed?
    return future
}
