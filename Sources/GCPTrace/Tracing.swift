import Foundation
import Logging
import OAuth2
import GRPC
import NIO
import GCPCore

public struct Tracing: Dependency {

    private static let logger = Logger(label: "trace.write")

    static var _client: Google_Devtools_Cloudtrace_V2_TraceServiceAsyncClient!

    static var authorization = Authorization(scopes: [
        "https://www.googleapis.com/auth/trace.append",
        "https://www.googleapis.com/auth/cloud-platform",
    ])

    public static func bootstrap(eventLoopGroup: EventLoopGroup) {
        let channel = ClientConnection
            .usingTLSBackedByNIOSSL(on: eventLoopGroup)
            .connect(host: "cloudtrace.googleapis.com", port: 443)

        _client = Google_Devtools_Cloudtrace_V2_TraceServiceAsyncClient(channel: channel)

        scheduleRepeatingWriteTimer()
    }

    public static func shutdown() async throws {
        try await lastWriteTask?.value
    }

    // MARK: - Config

    public static var projectID: String = ProcessInfo.processInfo.environment["GCP_PROJECT_ID"] ?? ""

    public static var writeInterval: TimeInterval = 30

    public static var maximumBatchSize = 500

    // MARK: - Write

    static var lastWriteTask: Task<(), Error>?

    static var buffer = [Span]() // TODO: Should we reserve capacity from `maximumBatchSize`?

    static func bufferWrite(span: Span) {
        assert(span.ended != nil, "Scheduled span has not ended.")

#if DEBUG
        if _client == nil {
            let duration = span.ended!.timeIntervalSince1970 - span.started.timeIntervalSince1970
            logger.trace("Trace operation recorded: \(span.name) (\(duration)s)")
            return
        }
#endif

        if buffer.count + 1 > maximumBatchSize {
            write()
        }
        buffer.append(span)
    }

    static func write() {
        let spans = buffer
        buffer.removeAll(keepingCapacity: true)

#if DEBUG
        if _client == nil {
            return // Don't write spans in development
        }
#endif

        logger.debug("Writing trace spans...")

        lastWriteTask = Task {
            do {
                try await _client.ensureAuthentication(authorization: &authorization)

                _ = try await _client.batchWriteSpans(.with {
                    $0.name = "projects/\(projectID)"
                    $0.spans = spans.map(encode)
                })
            } catch {
                logger.error("Error writing trace spans: \(error)")
            }
        }
    }

    private static func encode(span: Span) -> Google_Devtools_Cloudtrace_V2_Span {
        let spanIDString = span.id.stringValue
        return .with {
            $0.name = "projects/\(projectID)/traces/\(span.traceID.stringValue)/spans/\(spanIDString)"
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
//            $0.stackTrace
//            $0.timeEvents
//            $0.links
//            $0.childSpanCount
//            $0.spanKind
        }
    }

    private static func encode(attributes: [String: AttributableValue]) -> Google_Devtools_Cloudtrace_V2_Span.Attributes {
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

    // MARK: - Write Timer

    private static func scheduleRepeatingWriteTimer() {
        logger.debug("Scheduling write timer...")

        let timer = Timer(timeInterval: writeInterval, repeats: true, block: writeTimerHit)
        RunLoop.current.add(timer, forMode: .common)
    }

    private static func writeTimerHit(timer: Timer) {
        guard !buffer.isEmpty else {
            logger.debug("Write hit without any spans.")
            return
        }

        logger.debug("Write hit with spans.")
        write()
    }
}