public protocol ParentableNamespaceableKey: AnyKey where Parent: AnyKey {

    init(id: ID, parent: Parent, namespace: Namespace)
}

extension ParentableNamespaceableKey {

    public static func _init(id: ID, parent: Parent, namespace: Namespace) -> Self {
        self.init(id: id, parent: parent, namespace: namespace)
    }

    public static func incomplete(parent: Parent, namespace: Namespace) -> Self {
        Self.init(id: .incomplete, parent: parent, namespace: namespace)
    }

    public static func uniq(_ id: Int64, parent: Parent, namespace: Namespace) -> Self {
        Self.init(id: .uniq(id), parent: parent, namespace: namespace)
    }

    public static func named(_ id: String, parent: Parent, namespace: Namespace) -> Self {
        Self.init(id: .named(id), parent: parent, namespace: namespace)
    }
}

// MARK: - Hashable

extension ParentableNamespaceableKey {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(parent)
        hasher.combine(namespace)
    }
}

// MARK: - Equatable

extension ParentableNamespaceableKey {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.parent == rhs.parent && lhs.namespace == rhs.namespace
    }
}
