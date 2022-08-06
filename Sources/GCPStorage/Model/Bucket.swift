import Foundation

public struct Bucket {

    public let name: String

    public init(name: String) {
        self.name = name
    }

    // MARK: - Requests

    var urlEncoded: String {
        name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}
