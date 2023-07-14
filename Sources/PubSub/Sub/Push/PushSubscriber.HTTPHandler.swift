import Foundation
import NIO
import NIOHTTP1

extension PushSubscriber {

    final class HTTPHandler: ChannelInboundHandler {

        typealias InboundIn = HTTPServerRequestPart

        let handle: (Incoming) async -> Bool
        let decoder: JSONDecoder

        init(handle: @escaping (Incoming) async -> Bool) {
            self.handle = handle
            self.decoder = JSONDecoder()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            let reqPart = unwrapInboundIn(data)
            let channel = context.channel

            switch reqPart {
            case .head:
                break
            case .body(let body):
                Task {
                    let isSuccess: Bool
                    do {
                        let incoming = try decoder.decode(Incoming.self, from: body)
                        isSuccess = await handle(incoming)
                    } catch {
                        PushSubscriber.logger.warning("Error parsing incoming message: \(error)", metadata: [
                            "data": .string(String(buffer: body)),
                        ])
                        isSuccess = false
                    }

                    var head = HTTPResponseHead(version: .http1_1, status: isSuccess ? .noContent : .internalServerError)
                    head.headers.add(name: "Keep-Alive", value: "timeout=5, max=1000")
                    _ = channel.write(HTTPServerResponsePart.head(head))
                    _ = channel.write(HTTPServerResponsePart.body(.byteBuffer(.init())))
                    _ = channel.write(HTTPServerResponsePart.end(nil))
                    channel.flush()
                }
            case .end:
                break
            }
        }

        func errorCaught(context: ChannelHandlerContext, error: Error) {
            PushSubscriber.logger.warning("Socket error, closing connection: \(error)")
            context.close(promise: nil)
        }
    }
}
