public struct Database: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible, Sendable {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: - SQL

    func sql() -> String {
        "`" + rawValue + "`"
    }

    // MARK: - CustomStringConvertible

    public var description: String { rawValue }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String { "`" + rawValue + "`" }
}
