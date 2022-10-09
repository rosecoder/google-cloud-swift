public struct Database: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: - CustomStringConvertible

    public var description: String { rawValue }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String { "`" + rawValue + "`" }
}
