public protocol IndependentNamespaceableKey: AnyKey where Parent == Void {

    init(id: ID, namespace: Namespace)
}

extension IndependentNamespaceableKey {

    public var parent: Parent { () }

    public static func _init(id: ID, parent: Parent, namespace: Namespace) -> Self {
        self.init(id: id, namespace: namespace)
    }

    public static func incomplete(namespace: Namespace) -> Self {
        Self.init(id: .incomplete, namespace: namespace)
    }

    public static func uniq(_ id: Int64, namespace: Namespace) -> Self {
        Self.init(id: .uniq(id), namespace: namespace)
    }

    public static func named(_ id: String, namespace: Namespace) -> Self {
        Self.init(id: .named(id), namespace: namespace)
    }
}

// MARK: - Hashable

extension IndependentNamespaceableKey {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(namespace)
    }
}

// MARK: - Equatable

extension IndependentNamespaceableKey {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.namespace == rhs.namespace
    }
}
