import Foundation

public protocol Message {

    var data: Data { get }
    var attributes: [String: String] { get }
}
