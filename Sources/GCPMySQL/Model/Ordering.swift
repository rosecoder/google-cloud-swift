import MySQLNIO

public struct Ordering: Equatable {

    public let property: PropertyReference
    public let order: Order

    public init(property: PropertyReference, order: Order = .ascending) {
        self.property = property
        self.order = order
    }

    public enum Order: Equatable {
        case ascending
        case descending
    }

    // MARK: - SQL

    func sql(binds: inout [MySQLData]) -> String {
        switch order {
        case .ascending:
            return property.sql(binds: &binds)
        case .descending:
            return property.sql(binds: &binds) + " DESC"
        }
    }
}
