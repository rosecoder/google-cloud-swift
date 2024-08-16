import Foundation
import GRPC

extension Span {

    public struct Status: Sendable, Equatable, Codable {

        public typealias Code = GRPCStatus.Code

        public let code: Code
        public let message: String?

        public init(code: Code, message: String? = nil) {
            self.code = code
            self.message = message
        }

        // MARK: - Codable

        enum CodingKeys: String, CodingKey {
            case code
            case message
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(code.rawValue, forKey: .code)
            try container.encode(message, forKey: .message)
        }

        public struct InvalidCodeError: Error {}

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard let code = Code(rawValue: try container.decode(Int.self, forKey: .code)) else {
                throw InvalidCodeError()
            }

            self.code = code
            self.message = try container.decode(String.self, forKey: .message)
        }
    }
}
