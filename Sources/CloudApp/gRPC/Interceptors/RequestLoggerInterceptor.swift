import Logging
import GRPCCore

public struct RequestLoggerInterceptor: ServerInterceptor {

    private let logger: Logger?

    public init(useLogger: Bool) {
        self.logger = useLogger ? Logger(label: "request") : nil
    }

    public func intercept<Input: Sendable, Output: Sendable>(
        request: StreamingServerRequest<Input>,
        context: ServerContext,
        next: (StreamingServerRequest<Input>, ServerContext) async throws -> StreamingServerResponse<Output>
    ) async throws -> StreamingServerResponse<Output> {
        let start = ContinuousClock.now
        do {
            let result = try await next(request, context)
            let end = ContinuousClock.now
            log(start: start, end: end, result: .success(()), context: context)
            return result
        } catch {
            let end = ContinuousClock.now
            log(start: start, end: end, result: .failure(error), context: context)
            throw error
        }
    }

    private func log(start: ContinuousClock.Instant, end: ContinuousClock.Instant, result: Result<Void, Error>, context: ServerContext) {
        let durationComponents = (end - start).components
        let duration = String(format: "%.2fms", Double(durationComponents.attoseconds) / 1e15 + (Double(durationComponents.seconds) * 1000))
        let method = context.descriptor.method
        if var logger {
            logger[metadataKey: "method"] = .string(method)

            switch result {
            case .success:
                logger.info("OK in \(duration)")
            case .failure(let error):
                logger.error("\((error as? RPCError)?.code.description ?? "failed") in \(duration): \(error)")
            }
        } else {
            switch result {
            case .success:
                print("\u{001B}[32m✓\u{001B}[0m \(method) in \(duration)")
            case .failure(let error):
                print("\u{001B}[31m✗\u{001B}[0m \(method) in \(duration) \u{001B}[31m\(error)\u{001B}[0m")
            }
        }
    }
}