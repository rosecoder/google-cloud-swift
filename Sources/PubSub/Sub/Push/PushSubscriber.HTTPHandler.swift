import Foundation
import NIO
import NIOHTTP1

extension PushSubscriber {

    final class HTTPHandler: ChannelInboundHandler {

        typealias InboundIn = HTTPServerRequestPart

        private let handle: (Incoming) async -> Response

        private var receivedHead: HTTPRequestHead?
        private var buffer: ByteBuffer?

        private static let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            return decoder
        }()

        init(handle: @escaping (Incoming) async -> Response) {
            self.handle = handle
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            let reqPart = unwrapInboundIn(data)
            let channel = context.channel

            switch reqPart {
            case .head(let head):
                self.receivedHead = head
            case .body(var body):
                if buffer != nil {
                    self.buffer!.writeBuffer(&body)
                } else {
                    self.buffer = body
                }
            case .end:
                guard let receivedHead, let buffer else {
                    PushSubscriber.logger.warning("Channel read end without head and/or buffer")
                    context.close(promise: nil)
                    return
                }
                self.receivedHead = nil
                self.buffer = nil

                Task {
                    let response: Response
                    do {
                        let incoming = try Self.decoder.decode(Incoming.self, from: buffer)
                        response = await handle(incoming)
                    } catch {
                        PushSubscriber.logger.warning("Error parsing incoming message: \(error)", metadata: [
                            "data": .string(String(buffer: buffer)),
                        ])
                        response = .unexpectedCallerBehavior
                    }

                    var head = HTTPResponseHead(version: .http1_1, status: response.httpStatus)
                    if receivedHead.isKeepAlive {
                        head.headers.add(name: "Keep-Alive", value: "timeout=5, max=1000")
                    }
                    _ = channel.write(HTTPServerResponsePart.head(head))
                    _ = channel.write(HTTPServerResponsePart.body(.byteBuffer(.init())))
                    channel.writeAndFlush(HTTPServerResponsePart.end(nil)).whenComplete { _ in
                        if !receivedHead.isKeepAlive {
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
