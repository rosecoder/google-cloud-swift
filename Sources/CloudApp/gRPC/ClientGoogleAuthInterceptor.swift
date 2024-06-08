import Foundation
import GRPC
import NIO
import AsyncHTTPClient
import CloudCore

private let coordinator = IDTokenCoordinator()

public final class ClientGoogleAuthInterceptor<Request, Response, DependencyType: GRPCDependency>: GRPC.ClientInterceptor<Request, Response> {

    private let targetAudience: String

    private var idTokenPromise: EventLoopFuture<Void>?

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
            idTokenPromise = coordinator.idToken(targetAudience: targetAudience, eventLoop: context.eventLoop)
                .map { accessToken, _ in
                    headers.replaceOrAdd(name: "Authorization", value: "Bearer " + accessToken)
                    context.send(.metadata(headers), promise: promise)
                }
        default:
            if let idTokenPromise {
                idTokenPromise.whenComplete { result in
                    switch result {
                    case .failure(let error):
                        context.errorCaught(error)
                    case .success:
                        context.send(part, promise: promise)
                    }
                }
            } else {
                context.send(part, promise: promise)
            }
        }
    }
}

private actor IDTokenCoordinator {

    private var activeIDTokenTasks = [String: Task<(String, Date), Error>]()
    private let client = HTTPClient(eventLoopGroupProvider: .shared(_unsafeInitializedEventLoopGroup))

    private struct IDTokenPayload: Decodable {

        let exp: TimeInterval
    }

    private enum IDTokenError: Error {
        case noData
        case notJWT(String)
        case invalidJWTPayload(String)
    }

    fileprivate nonisolated func idToken(targetAudience: String, eventLoop: EventLoop) -> EventLoopFuture<(String, Date)> {
        let promise = eventLoop.makePromise(of: (String, Date).self)
        promise.completeWithTask {
            try await self.idToken(targetAudience: targetAudience)
        }
        return promise.futureResult
    }

    fileprivate func idToken(targetAudience: String) async throws -> (String, Date) {
        if let task = activeIDTokenTasks[targetAudience] {
            let (idToken, expiration) = try await task.value
            if expiration >= Date() {
                return (idToken, expiration)
            }
        }

        let task = Task {
            return try await requestIDToken(targetAudience: targetAudience)
        }
        activeIDTokenTasks[targetAudience] = task
        return try await task.value
    }

    private func requestIDToken(targetAudience: String) async throws -> (String, Date) {
        var urlComponents = URLComponents(string: "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity")!
        urlComponents.queryItems = [
            .init(name: "audience", value: targetAudience),
        ]

        var request = HTTPClientRequest(url: urlComponents.string!)
        request.headers.add(name: "Metadata-Flavor", value: "Google")

        let response = try await client.execute(request, timeout: .seconds(5))
        let body = try await response.body.collect(upTo: 1024 * 10) // 10 KB

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
}
