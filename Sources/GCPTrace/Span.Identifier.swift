import Foundation

extension Span {

    public struct Identifier: Equatable, Codable {

        public typealias RawValue = UInt64

        public let rawValue: RawValue

        /// Initializes a new identifier with a new unique raw value.
        public init() {
            self.rawValue = RawValue.random(in: 1..<RawValue.max)
        }

        init(rawValue: RawValue) {
            precondition(rawValue > 0, "Span id must not be 0")

            self.rawValue = rawValue
        }

        public init?(stringValue: String) {
            guard
                stringValue.count == 16,
                let part = UInt64(stringValue[..<stringValue.index(stringValue.startIndex, offsetBy: 16)], radix: 16),
                part != 0
            else {
                return nil
            }

            self.rawValue = part
        }

        // MARK: - String Representation

        public var stringValue: String {
            rawValue.prefixedHexRepresentation
        }

        // MARK: - Codable

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(stringValue)
        }

        public struct InvalidStringRepresentationError: Error {}

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            guard let rawValue = UInt64(stringValue, radix: 16) else {
                throw InvalidStringRepresentationError()
            }

            self.rawValue = rawValue
        }
    }
}
