import Foundation
import CloudCore
import Logging

protocol IncomingRawMessage {

    var id: String { get }
    var attributes: [String: String] { get }
}
