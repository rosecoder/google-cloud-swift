public protocol ParentableKey: AnyKey where Parent: AnyKey {

    init(id: ID, parent: Parent)
}

extension ParentableKey {
    
    public var namespace: Namespace { .default }

    public static func _init(id: ID, parent: Parent, namespace: Namespace) -> Self {
        self.init(id: id, parent: parent)
    }

    public static func incomplete(parent: Parent) -> Self {
        Self.init(id: .incomplete, parent: parent)
    }

    public static func uniq(_ id: Int64, parent: Parent) -> Self {
        Self.init(id: .uniq(id), parent: parent)
    }

    public static func named(_ id: String, parent: Parent) -> Self {
        Self.init(id: .named(id), parent: parent)
    }
}

// MARK: - Hashable

extension ParentableKey {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(parent)
    }
}

// MARK: - Equatable

extension ParentableKey {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.parent == rhs.parent
    }
}
