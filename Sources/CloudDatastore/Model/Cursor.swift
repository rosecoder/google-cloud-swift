import Foundation

public struct Cursor: Equatable, Hashable, Sendable {

    public let rawValue: Data

    public init(rawValue: Data) {
        self.rawValue = rawValue
    }

    // MARK: - String Representation

    public init?(stringValue: String) {
        guard let rawValue = Data(base64Encoded: stringValue) else {
            return nil
        }
        self.rawValue = rawValue
    }

    public var stringValue: String {
        rawValue.base64EncodedString()
    }
}
