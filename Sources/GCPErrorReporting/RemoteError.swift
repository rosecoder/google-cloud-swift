import Foundation

struct RemoteError: Error, Decodable {

    let code: String  // TODO: Find all error codes and parse into an enum?
    let message: String

    // MARK: - Decodable

    private enum RootCodingKeys: String, CodingKey {
        case error = "error"
    }

    private enum CodingKeys: String, CodingKey {
        case code = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)

        self.code = try container.decode(String.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
