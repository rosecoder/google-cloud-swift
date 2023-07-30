import CloudCore

/// Set of options for a dependency.
public struct DependencyOptions {

    public let type: Dependency.Type

    public init(_ type: Dependency.Type) {
        self.type = type
    }
}
