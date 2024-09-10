import Foundation

public struct Object: Sendable {

    public let path: String

    public init(path: String) {
        self.path = path
    }

    // MARK: - Requests

    var urlEncoded: String {
        path.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }

#if DEBUG
    func localStorageURL(in bucket: Bucket) -> URL {
        URL(fileURLWithPath: bucket.localStorageURL.path + "/" + path)
    }
#endif
}
