import Foundation

/// Configuration for a single property in an `Entry`.
public struct PropertyConfiguration {

    /// If the value should be excluded from all indexes including those defined explicitly.
    public var excludeFromIndexes: Bool

    public init(
        excludeFromIndexes: Bool = false
    ) {
        self.excludeFromIndexes = excludeFromIndexes
    }
}
