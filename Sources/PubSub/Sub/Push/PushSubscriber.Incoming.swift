import Foundation

extension PushSubscriber {

    struct Incoming: Decodable {

        let message: Message
        let subscription: String

        struct Message: Decodable, IncomingRawMessage {

            let id: String
            let data: Data
            let published: Date
            let attributes: [String: String]

            enum CodingKeys: CodingKey {
                case attributes
                case data
                case messageId
                case message_id
                case publishTime
                case publish_time
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decodeIfPresent(String.self, forKey: .messageId) ?? (try container.decode(String.self, forKey: .message_id))
                self.published = try container.decodeIfPresent(Date.self, forKey: .publishTime) ?? (try container.decode(Date.self, forKey: .publish_time))
                self.attributes = try container.decode([String: String].self, forKey: .attributes)

                let dataBase64 = try container.decode(String.self, forKey: .data)
                guard let data = Data(base64Encoded: dataBase64) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath + [CodingKeys.data], debugDescription: "Data is not base64 encoded: \(dataBase64)"))
                }
                self.data = data
            }
        }
    }
}
