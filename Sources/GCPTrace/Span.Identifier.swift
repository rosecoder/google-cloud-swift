import Foundation

extension Span {

    public struct Identifier: Equatable {

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

        // MARK: - String Representation

        public var stringValue: String {
            rawValue.prefixedHexRepresentation
        }
    }
}
