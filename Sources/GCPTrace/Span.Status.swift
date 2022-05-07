import Foundation
import GRPC

extension Span {

    public struct Status {

        public typealias Code = GRPCStatus.Code

        public let code: Code
        public let message: String?

        public init(code: Code, message: String? = nil) {
            self.code = code
            self.message = message
        }
    }
}
