import Core

/// Set of options for a dependency.
public struct DependencyOptions {

    public let type: Dependency.Type
    public let isRequired: Bool

    public init(
        _ type: Dependency.Type,
        isRequired: Bool = true
    ) {
        self.type = type
        self.isRequired = isRequired
    }
}
