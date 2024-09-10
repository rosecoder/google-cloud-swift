public protocol _CodableKey: Codable {

    /// Internal. Do not use.
    init(nextElement: () -> Any, namespace: Namespace)

    /// Internal. Do not use.
    func _enumeratePathElement(nextElement: (Any, Namespace) -> Void)
}

/// Any type of a key for an `Entity`.
///
/// Never implement this protocol directly. Instead use one of the following:
/// - `IndependentKey`: Key with no parent and only in default namespace.
/// - `IndependentNamespaceableKey`: Key with no parent and in specifyed namespace.
/// - `ParentableKey`: Key with parent, but only in default namespace.
/// - `ParentableNamespaceableKey`: Key with  parent and in specifyed namespace.
public protocol AnyKey: Sendable, _CodableKey, Hashable, CustomDebugStringConvertible, QueryFilterValueKey {

    associatedtype Parent

    static var kind: String { get }
    var id: ID { get }
    var parent: Parent { get }

    /// Partition namespace for key. Note that this property is only used  for keys not being a parent.
    var namespace: Namespace { get }

    /// Internal. Do not use.
    static func _init(id: ID, parent: Parent, namespace: Namespace) -> Self
}

// MARK: - CustomDebugStringConvertible

extension AnyKey {

    public var debugDescriptionNoNamesapce: String {
        "\(Self.kind):\(id.debugDescription)"
    }
}

extension AnyKey where Parent: AnyKey {

    public var debugDescription: String {
        "\(namespace.rawValue).\(parent.debugDescriptionNoNamesapce).\(debugDescriptionNoNamesapce)"
    }
}

extension AnyKey where Parent == Void {

    public var debugDescription: String {
        "\(namespace.rawValue).\(debugDescriptionNoNamesapce)"
    }
}

// MARK: - Encoding

extension AnyKey where Parent: AnyKey {

    public func encode(to encoder: Encoder) throws {
        // This method is actually not used when encoding with EntityEncoder.
        // Only implemented to comply with Codable and if some other encoder would be used.

        var container = encoder.unkeyedContainer()
        try container.encode(namespace)
        try container.encode(Self.kind)
        try container.encode(id)
        try container.encode(parent)
    }

    public func _enumeratePathElement(nextElement: (Any, Namespace) -> Void) {
        let pathElement: Google_Datastore_V1_Key.PathElement = .with {
            $0.kind = Self.kind
            $0.idType = self.id.raw
        }
        parent._enumeratePathElement(nextElement: nextElement)
        nextElement(pathElement, namespace)
    }
}

extension AnyKey where Parent == Void {

    public func encode(to encoder: Encoder) throws {
        // This method is actually not used when encoding with EntityEncoder.
        // Only implemented to comply with Codable and if some other encoder would be used.

        var container = encoder.unkeyedContainer()
        try container.encode(namespace)
        try container.encode(Self.kind)
        try container.encode(id)
    }

    public func _enumeratePathElement(nextElement: (Any, Namespace) -> Void) {
        let pathElement: Google_Datastore_V1_Key.PathElement = .with {
            $0.kind = Self.kind
            $0.idType = self.id.raw
        }
        nextElement(pathElement, namespace)
    }
}

extension _CodableKey {

    var raw: Google_Datastore_V1_Key {
        var pathElements = [Google_Datastore_V1_Key.PathElement]()
        var rootNamespace = Namespace.default
        _enumeratePathElement { pathElement, namespace in
            rootNamespace = namespace
            pathElements.append(pathElement as! Google_Datastore_V1_Key.PathElement)
        }

        return .with {
            $0.partitionID.namespaceID = rootNamespace.rawValue
            $0.path = pathElements
        }
    }

    public var _rawQueryFilterValue: Any {
        Google_Datastore_V1_Value.OneOf_ValueType.keyValue(raw)
    }
}

// MARK: - Decoding

extension AnyKey where Parent: AnyKey {

    public init(from decoder: Decoder) throws {
        // This method is actually not used when decoding with EntityEncoder.
        // Only implemented to comply with Codable and if some other decoder would be used.

        var container = try decoder.unkeyedContainer()
        let namespace = try container.decode(Namespace.self)
        _ = try container.decode(String.self) // kind is always staticilly set
        let id = try container.decode(ID.self)
        let parent = try container.decode(Parent.self)

        self = Self._init(id: id, parent: parent, namespace: namespace)
    }

    public init(nextElement: () -> Any, namespace: Namespace) {
        let raw = nextElement() as! Google_Datastore_V1_Key.PathElement

        self = Self._init(
            id: ID(raw: raw.idType),
            parent: Parent.init(nextElement: nextElement, namespace: namespace),
            namespace: namespace
        )
    }
}

extension AnyKey where Parent == Void {

    public init(from decoder: Decoder) throws {
        // This method is actually not used when decoding with EntityEncoder.
        // Only implemented to comply with Codable and if some other decoder would be used.

        var container = try decoder.unkeyedContainer()
        let namespace = try container.decode(Namespace.self)
        _ = try container.decode(String.self) // kind is always staticilly set
        let id = try container.decode(ID.self)

        self = Self._init(id: id, parent: (), namespace: namespace)
    }

    public init(nextElement: () -> Any, namespace: Namespace) {
        let raw = nextElement() as! Google_Datastore_V1_Key.PathElement

        self = Self._init(
            id: ID(raw: raw.idType),
            parent: (),
            namespace: namespace
        )
    }
}

extension _CodableKey {

    init(raw: Google_Datastore_V1_Key) {
        var index = raw.path.count - 1
        self.init(
            nextElement: {
                defer { index -= 1 }
                return raw.path[index]
            },
            namespace: Namespace(rawValue: raw.partitionID.namespaceID)
        )
    }
}
