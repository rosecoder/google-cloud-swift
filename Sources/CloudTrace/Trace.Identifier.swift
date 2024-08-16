import Foundation

extension Trace {

    public struct Identifier: Sendable, Equatable, Codable {

        public typealias RawValue = (UInt64, UInt64)

        public let rawValue: RawValue

        /// Initializes a new identifier with a new unique raw value.
        public init() {
            self.rawValue = (
                UInt64.random(in: 1..<UInt64.max),
                UInt64.random(in: 1..<UInt64.max)
            )
        }

        public init(rawValue: RawValue) {
            precondition(rawValue.0 > 0 || rawValue.1 > 0, "Trace id must not be 0")

            self.rawValue = rawValue
        }

        public init?(stringValue: String) {
            guard
                stringValue.count == 32,
                let part0 = UInt64(stringValue[..<stringValue.index(stringValue.startIndex, offsetBy: 16)], radix: 16),
                let part1 = UInt64(stringValue[stringValue.index(stringValue.startIndex, offsetBy: 16)...], radix: 16),
                !(part0 == 0 && part1 == 0)
            else {
                return nil
            }

            self.rawValue = (part0, part1)
        }

        // MARK: - String Representation

        public var stringValue: String {
            rawValue.0.prefixedHexRepresentation + rawValue.1.prefixedHexRepresentation
        }

        // MARK: - Equatable

        public static func ==(lhs: Identifier, rhs: Identifier) -> Bool {
            lhs.rawValue == rhs.rawValue
        }

        // MARK: - Codable

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(stringValue)
        }

        public struct InvalidStringRepresentationError: Error {}

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let id = Identifier(stringValue: try container.decode(String.self)) {
                self = id
            } else {
                throw InvalidStringRepresentationError()
            }
        }
    }
}
