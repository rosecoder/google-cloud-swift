public struct Namespace: Sendable, RawRepresentable, Equatable, Hashable, Codable, CustomStringConvertible, CustomDebugStringConvertible {

    public typealias RawValue = String

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    public var rawValue: RawValue

    public static let `default` = Namespace(rawValue: "")

    // MARK: - Codable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self.init(rawValue: rawValue)
    }

    // MARK: - CustomStringConvertible

    public var description: String { rawValue }

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String { rawValue }
}
