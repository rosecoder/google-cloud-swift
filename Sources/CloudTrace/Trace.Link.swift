import Foundation

extension Span {

    public struct Link: Sendable, Codable, Equatable {

        public let trace: Trace
        public var kind: Kind
        public var attributes: [String: AttributableValue]

        public init(
            trace: Trace,
            kind: Kind,
            attributes: [String: AttributableValue] = [:]
        ) {
            self.trace = trace
            self.kind = kind
            self.attributes = attributes
        }

        public enum Kind: Sendable, Codable, Equatable {
            case unspecified
            case child
            case parent
        }

        // MARK: - Equatable

        public static func == (lhs: Link, rhs: Link) -> Bool {
            lhs.trace == rhs.trace && lhs.kind == rhs.kind
        }

        // MARK: - Codable

        enum CodingKeys: String, CodingKey {
            case trace
            case kind
            case attributes
        }

        private struct GenericStringKey: CodingKey {

            let stringValue: String
            var intValue: Int? { Int(stringValue) }

            init(stringValue: String) {
                self.stringValue = stringValue
            }

            init?(intValue: Int) {
                self.stringValue = String(intValue)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(trace, forKey: .trace)
            try container.encode(kind, forKey: .kind)

            var attributesContainer = container.nestedContainer(keyedBy: GenericStringKey.self, forKey: .attributes)
            for (key, value) in attributes {
                try attributesContainer.encode(value._codableValue, forKey: GenericStringKey(stringValue: key))
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.trace = try container.decode(Trace.self, forKey: .trace)
            self.kind = try container.decode(Kind.self, forKey: .kind)

            let attributesContainer = try container.nestedContainer(keyedBy: GenericStringKey.self, forKey: .attributes)
            self.attributes = [:]
            for key in attributesContainer.allKeys {
                self.attributes[key.stringValue] = try attributesContainer
                    .decode(AttributableValueCodableValue.self, forKey: GenericStringKey(stringValue: key.stringValue))
                    .attributableValue
            }
        }
    }
}
