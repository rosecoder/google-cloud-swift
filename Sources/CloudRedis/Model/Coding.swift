import Foundation
import NIO

public protocol Encoder {

    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

public protocol Decoder {

    func decode<T: Decodable>(_ type: T.Type, from buffer: ByteBuffer) throws -> T
}

extension JSONEncoder: Encoder {}
extension JSONDecoder: Decoder {}
