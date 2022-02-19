public protocol IndependentKey: AnyKey where Parent == Void {

    init(id: ID)
}

extension IndependentKey {

    public var parent: Parent { () }
    public var namespace: Namespace { .default }

    public static func _init(id: ID, parent: Parent, namespace: Namespace) -> Self {
        self.init(id: id)
    }

    public static var incomplete: Self {
        Self.init(id: .incomplete)
    }

    public static func uniq(_ id: Int64) -> Self {
        Self.init(id: .uniq(id))
    }

    public static func named(_ id: String) -> Self {
        Self.init(id: .named(id))
    }
}

// MARK: - Hashable

extension IndependentKey {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension IndependentKey {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
