import Foundation

extension Span {

    public mutating func annotate(description: String, attributes: [String: AttributableValue] = [:]) {
        timeEvents.append(TimeEvent(
            content: .annotation(.init(description: description, attributes: attributes))
        ))
    }
}

extension Span {

    public struct TimeEvent: Sendable, Codable, Equatable {

        public let date: Date
        public let content: Content

        public init(
            date: Date = Date(),
            content: Content
        ) {
            self.date = date
            self.content = content
        }

        public enum Content: Sendable, Codable {
            case annotation(Annotation)
        }

        public struct Annotation: Sendable, Codable {

            public let description: String
            public let attributes: [String: AttributableValue]

            public init(description: String, attributes: [String: AttributableValue]) {
                self.description = description
                self.attributes = attributes
            }

            enum CodingKeys: String, CodingKey {
                case description
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

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(description, forKey: .description)

                var attributesContainer = container.nestedContainer(keyedBy: GenericStringKey.self, forKey: .attributes)
                for (key, value) in attributes {
                    try attributesContainer.encode(value._codableValue, forKey: GenericStringKey(stringValue: key))
                }
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.description = try container.decode(String.self, forKey: .description)

                let attributesContainer = try container.nestedContainer(keyedBy: GenericStringKey.self, forKey: .attributes)
                var attributes = [String: AttributableValue]()
                for key in attributesContainer.allKeys {
                    attributes[key.stringValue] = try attributesContainer
                        .decode(AttributableValueCodableValue.self, forKey: GenericStringKey(stringValue: key.stringValue))
                        .attributableValue
                }
                self.attributes = attributes
            }
        }

        // MARK: - Equatable

        public static func == (lhs: TimeEvent, rhs: TimeEvent) -> Bool {
            lhs.date == rhs.date
        }

        // MARK: - Codable

        enum CodingKeys: String, CodingKey {
            case date
            case content
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(date, forKey: .date)
            try container.encode(content, forKey: .content)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.date = try container.decode(Date.self, forKey: .date)
            self.content = try container.decode(Content.self, forKey: .content)
        }
    }
}
