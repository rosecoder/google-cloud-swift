import Foundation
import NIO
import NIOHTTP1
import CloudCore
import Tracing
import Logging

private struct HTTPHeadersExtractor: Extractor {

    func extract(key: String, from carrier: HTTPHeaders) -> String? {
        carrier.first(name: key)
    }
}

extension PushSubscriber {

    final class HTTPHandler: ChannelInboundHandler {

        typealias InboundIn = HTTPServerRequestPart

        private let handle: @Sendable (Incoming, Span) async -> Response

        private var isKeepAlive = false
        private var context: ServiceContext = .topLevel
        private var buffer: ByteBuffer?

        let logger = Logger(label: "pubsub.subscriber")

        static let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64

            let dateFormats: [String] = [
                "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
                "yyyy-MM-dd'T'HH:mm:ss'Z'",
            ]
            let dateFormatters = dateFormats.map {
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = $0
                return formatter
            }
            decoder.dateDecodingStrategy = .custom({ decoder in
                let container = try decoder.singleValueContainer()
                let string = try container.decode(String.self)
                for formatter in dateFormatters {
                    if let date = formatter.date(from: string) {
                        return date
                    }
                }
                throw DecodingError.dataCorrupted(.init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Date string does not match format expected by formatter."
                ))
            })

            return decoder
        }()

        init(handle: @Sendable @escaping (Incoming, Span) async -> Response) {
            self.handle = handle
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            let reqPart = unwrapInboundIn(data)
            let channel = context.channel

            switch reqPart {
            case .head(let head):
                self.isKeepAlive = head.isKeepAlive

                InstrumentationSystem.instrument.extract(
                    head.headers,
                    into: &self.context,
                    using: HTTPHeadersExtractor()
                )
            case .body(var body):
                if buffer != nil {
                    self.buffer!.writeBuffer(&body)
                } else {
                    self.buffer = body
                }
            case .end:
                guard let buffer else {
                    logger.warning("Channel read end without head and/or buffer")
                    context.close(promise: nil)
                    return
                }
                self.buffer = nil

                Task { [handle, isKeepAlive, logger] in
                    let response: Response
                    do {
                        _ = buffer
                        let incoming = try HTTPHandler.decoder.decode(Incoming.self, from: buffer)
                        response = await withSpan("Subscription") { span in
                            await handle(incoming, span)
                        }
                    } catch {
                        logger.error("Error parsing incoming message: \(error)", metadata: [
                            "data": .string(String(buffer: buffer)),
                        ])
                        response = .unexpectedCallerBehavior
                    }

//                    if !(await Environment.current.isCPUAlwaysAllocated) {
//                        await Tracing.shared.writeIfNeeded()
//                        await Tracing.shared.waitForWrite()
//                    }

                    var head = HTTPResponseHead(version: .http1_1, status: response.httpStatus)
                    if isKeepAlive {
                        head.headers.add(name: "Keep-Alive", value: "timeout=5, max=1000")
                    }
                    _ = channel.write(HTTPServerResponsePart.head(head))
                    _ = channel.write(HTTPServerResponsePart.body(.byteBuffer(.init())))
                    channel.writeAndFlush(HTTPServerResponsePart.end(nil)).whenComplete { [isKeepAlive] _ in
                        if !isKeepAlive {
                            channel.close(promise: nil)
                        }
                    }
                }
            }
        }

        func errorCaught(context: ChannelHandlerContext, error: Error) {
            logger.warning("Socket error, closing connection: \(error)")
            context.close(promise: nil)
        }
    }
}
