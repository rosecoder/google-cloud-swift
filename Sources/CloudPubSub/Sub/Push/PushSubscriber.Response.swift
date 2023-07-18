import Foundation
import NIOHTTP1

extension PushSubscriber {

    enum Response {
        case success
        case failure
        case notFound
        case unexpectedCallerBehavior

        var httpStatus: HTTPResponseStatus {
            switch self {
            case .success:
                return .noContent
            case .failure:
                return .internalServerError
            case .notFound:
                return .notFound
            case .unexpectedCallerBehavior:
                return .badRequest
            }
        }
    }
}
