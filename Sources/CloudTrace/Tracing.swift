import Foundation
import Logging
import GRPC
import NIO
import CloudCore
import RetryableTask

public actor Tracing: Dependency {

    public static var shared = Tracing()

    private let logger = Logger(label: "trace.write")

    var _client: Google_Devtools_Cloudtrace_V2_TraceServiceAsyncClient!

    var authorization: Authorization!

    public func bootstrap(eventLoopGroup: EventLoopGroup) throws {
        authorization = try Authorization(scopes: [
            "https://www.googleapis.com/auth/trace.append",
            "https://www.googleapis.com/auth/cloud-platform",
        ], eventLoopGroup: eventLoopGroup)

        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "cloudtrace.googleapis.com", port: 443)

        _client = Google_Devtools_Cloudtrace_V2_TraceServiceAsyncClient(channel: channel)

        scheduleRepeatingWriteTimer()
    }

    public func shutdown() async throws {
        writeIfNeeded()
        await waitForWrite()
        try await authorization?.shutdown()
    }

    // MARK: - Config

    public static var projectID: String = Environment.current.projectID

    public static var writeInterval: TimeInterval = 10

    public static var maximumBatchSize = 500

    // MARK: - Write

    var lastWriteTask: Task<(), Error>?

    var buffer = [Span]() // TODO: Should we reserve capacity from `maximumBatchSize`?

    func bufferWrite(span: Span) {
        assert(span.ended != nil, "Scheduled span has not ended.")

#if DEBUG
        if _client == nil {
            let duration = span.ended!.timeIntervalSince1970 - span.started.timeIntervalSince1970
            logger.trace("Trace operation recorded: \(span.name) (\(duration)s)")
            return
        }
#endif

        if buffer.count + 1 > Self.maximumBatchSize {
            write()
        }
        buffer.append(span)
    }

    public func writeIfNeeded() {
        guard !buffer.isEmpty else {
            return
        }
        write()
    }

    public func waitForWrite() async {
        try? await lastWriteTask?.value
    }

    private func write() {
        let spans = buffer
        buffer.removeAll(keepingCapacity: true)

#if DEBUG
        if _client == nil {
            return // Don't write spans in development
        }
#endif

        logger.debug("Writing \(spans.count) trace span(s)...")

        lastWriteTask = Task {
            do {
                try await withRetryableTask(logger: logger) {
                    try await _write(spans: spans)
                }
                logger.debug("Successfully wrote spans.")
            } catch {
                logger.error("Error writing trace spans: \(error)")
            }
        }
    }

    private func _write(spans: [Span]) async throws {
        var _client = _client!
        try await _client.ensureAuthentication(authorization: authorization)
        self._client = _client

        _ = try await _client.batchWriteSpans(.with {
            $0.name = "projects/\(Self.projectID)"
            $0.spans = spans.map(encode)
        })
    }

    private func encode(span: Span) -> Google_Devtools_Cloudtrace_V2_Span {
        let spanIDString = span.id.stringValue
        return .with {
            $0.name = "projects/\(Self.projectID)/traces/\(span.traceID.stringValue)/spans/\(spanIDString)"
            $0.spanID = spanIDString
            $0.parentSpanID = span.parentID?.stringValue ?? ""
            $0.displayName = Google_Devtools_Cloudtrace_V2_TruncatableString(span.name, limit: 128)
            $0.startTime = .init(date: span.started)
            $0.endTime = .init(date: span.ended!)
            $0.attributes = encode(attributes: span.attributes)
            if let status = span.status {
                $0.status = .with {
                    $0.code = Int32(status.code.rawValue)
                    $0.message = status.message ?? ""
                }
            }
            $0.sameProcessAsParentSpan = .with {
                $0.value = span.sameProcessAsParent
            }
            $0.links = encode(links: span.links)
//            $0.stackTrace
//            $0.timeEvents
//            $0.childSpanCount
            $0.spanKind = encode(kind: span.kind)
        }
    }

    private func encode(attributes: [String: AttributableValue]) -> Google_Devtools_Cloudtrace_V2_Span.Attributes {

        // Well-known labels can be found here: https://github.com/googleapis/cloud-trace-nodejs/blob/c57a0b100d00fe0002544400c3958a17cc9751fb/src/trace-labels.ts

        var attributes = attributes
        let environment = Environment.current
        attributes["g.co/gae/app/module"] = environment.serviceName
        if let version = environment.version {
            attributes["g.co/gae/app/version"] = version
        }

        let limit: UInt8 = 32

        var encoded = Google_Devtools_Cloudtrace_V2_Span.Attributes.with {
            $0.droppedAttributesCount = 0
        }
        var count: UInt8 = 0
        for (key, value) in attributes {
            count += 1
            if count == limit {
                encoded.droppedAttributesCount = Int32(attributes.count - Int(limit))
                break
            }
            encoded.attributeMap[key] = (value._gcpTraceRawValue as! Google_Devtools_Cloudtrace_V2_AttributeValue)
        }
        return encoded
    }

    private func encode(links: [Span.Link]) -> Google_Devtools_Cloudtrace_V2_Span.Links {
        let limit: UInt8 = 128

        var encoded = Google_Devtools_Cloudtrace_V2_Span.Links.with {
            $0.droppedLinksCount = 0
            $0.link = []
            $0.link.reserveCapacity(min(links.count, Int(limit)))
        }
        var count: UInt8 = 0
        for link in links {
            count += 1
            if count == limit {
                encoded.droppedLinksCount = Int32(links.count - Int(limit))
                break
            }
            encoded.link.append(.with {
                $0.traceID = link.trace.id.stringValue
                $0.spanID = link.trace.spanID.stringValue
                switch link.kind {
                case .unspecified:
                    $0.type = .unspecified
                case .child:
                    $0.type = .childLinkedSpan
                case .parent:
                    $0.type = .parentLinkedSpan
                }
                $0.attributes = encode(attributes: link.attributes)
            })
        }
        return encoded
    }

    private func encode(kind: Span.Kind) -> Google_Devtools_Cloudtrace_V2_Span.SpanKind {
        switch kind {
        case .internal:
            return .internal
        case .server:
            return .server
        case .client:
            return .client
        case .producer:
            return .producer
        case .consumer:
            return .consumer
        }
    }

    // MARK: - Write Timer

    private func scheduleRepeatingWriteTimer() {
        let timer = Timer(timeInterval: Self.writeInterval, repeats: true) { _ in
            Task {
                await self.writeIfNeeded()
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
}
