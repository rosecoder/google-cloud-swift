import Foundation
import NIO
import NIOHTTP1
import CloudCore
import CloudTrace

extension PushSubscriber {

    final class HTTPHandler: ChannelInboundHandler {

        typealias InboundIn = HTTPServerRequestPart

        private let handle: (Incoming, Trace?) async -> Response

        private var isKeepAlive = false
        private var trace: Trace?
        private var buffer: ByteBuffer?

        private static let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64

            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            return decoder
        }()

        init(handle: @escaping (Incoming, Trace?) async -> Response) {
            self.handle = handle
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            let reqPart = unwrapInboundIn(data)
            let channel = context.channel

            switch reqPart {
            case .head(let head):
                self.isKeepAlive = head.isKeepAlive
                self.trace = head.headers["X-Cloud-Trace-Context"].first.flatMap { Trace(headerValue: $0) }
            case .body(var body):
                if buffer != nil {
                    self.buffer!.writeBuffer(&body)
                } else {
                    self.buffer = body
                }
            case .end:
                guard let buffer else {
                    PushSubscriber.logger.warning("Channel read end without head and/or buffer")
                    context.close(promise: nil)
                    return
                }
                let trace = self.trace

                self.buffer = nil
                self.trace = nil

                Task {
                    let response: Response
                    do {
                        let incoming = try Self.decoder.decode(Incoming.self, from: buffer)
                        response = await handle(incoming, trace)
                    } catch {
                        PushSubscriber.logger.warning("Error parsing incoming message: \(error)", metadata: [
                            "data": .string(String(buffer: buffer)),
                        ])
                        response = .unexpectedCallerBehavior
                    }

                    if !Environment.current.isCPUAlwaysAllocated {
                        Tracing.writeIfNeeded()
                        await Tracing.waitForWrite()
                    }

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
            PushSubscriber.logger.warning("Socket error, closing connection: \(error)")
            context.close(promise: nil)
        }
    }
}
