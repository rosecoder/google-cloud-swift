import Foundation

public struct Bucket: Sendable {

    public let name: String

    public init(name: String) {
        self.name = name
    }

    // MARK: - Requests

    var urlEncoded: String {
        name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }

#if DEBUG
    var localStorageURL: URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("GCPStorage")
            .appendingPathComponent("buckets")
            .appendingPathComponent(name)
    }
#endif
}
