import Foundation

extension Google_Pubsub_V1_PubsubMessage: IncomingRawMessage {

    var id: String {
        messageID
    }
}
