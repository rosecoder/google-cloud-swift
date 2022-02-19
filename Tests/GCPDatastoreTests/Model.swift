import XCTest
import GCPDatastore

// Using `Testttt`-prefix for kinds just in case someone would run tests against production.
// Running tests deletes all data before test is executed.

extension Namespace {

    static var test1: Namespace { Namespace(rawValue: "test1") }
}

struct User: Entity, Equatable {

    struct Key: IndependentKey {

        static let kind = "TesttttUser"

        let id: ID
    }

    var key: Key
    let email: String

    enum CodingKeys: String, CodingKey {
        case key
        case email = "Email"
    }
}

struct Access: Entity {

    struct Key: ParentableKey {

        static let kind = "TesttttAccess"

        let id: ID
        let parent: User.Key
    }

    var key: Key
    let token: String

    enum CodingKeys: String, CodingKey {
        case key
        case token = "Token"
    }
}

// MARK: -

struct IndependentKeyEntity: Entity, Equatable {

    struct Key: IndependentKey {

        static let kind = "Testttt-IndependentKeyEntity"

        let id: ID
    }

    var key: Key

    enum CodingKeys: String, CodingKey {
        case key
    }
}

struct ParentableKeyEntity: Entity, Equatable {

    struct Key: ParentableKey {

        static let kind = "Testttt-ParentableKeyEntity"

        let id: ID
        let parent: IndependentKeyEntity.Key
    }

    var key: Key

    enum CodingKeys: String, CodingKey {
        case key
    }
}

struct IndependentNamespaceableKeyEntity: Entity, Equatable {

    struct Key: IndependentNamespaceableKey {

        static let kind = "Testttt-IndependentNamespaceableKeyEntity"

        let id: ID
        let namespace: Namespace
    }

    var key: Key

    enum CodingKeys: String, CodingKey {
        case key
    }
}

struct ParentableNamespaceableKeyEntity: Entity, Equatable {

    struct Key: ParentableNamespaceableKey {

        static let kind = "Testttt-ParentableNamespaceableKeyEntity"

        let id: ID
        let parent: IndependentNamespaceableKeyEntity.Key
        let namespace: Namespace
    }

    var key: Key

    enum CodingKeys: String, CodingKey {
        case key
    }
}

struct AllPropertyTypeEntity: Entity, Equatable {

    struct Key: IndependentKey {

        static let kind = "Testttt-AllPropertyTypeEntity"

        let id: ID
    }

    var key: Key

    var string: String

    var int: Int
    var int8: Int8
    var int16: Int16
    var int32: Int32
    var int64: Int64
    var uInt: UInt
    var uInt8: UInt8
    var uInt16: UInt16
    var uInt32: UInt32
    var uInt64: UInt64

    var float: Float
    var double: Double

    var date: Date

    var data: Data

    var nilValue: String?

    var entity: User
    var array: [String]

    enum CodingKeys: String, CodingKey {
        case key

        case string = "String"

        case int = "Int"
        case int8 = "Int8"
        case int16 = "Int16"
        case int32 = "Int32"
        case int64 = "Int64"
        case uInt = "UInt"
        case uInt8 = "UInt8"
        case uInt16 = "UInt16"
        case uInt32 = "UInt32"
        case uInt64 = "UInt64"

        case float = "Float"
        case double = "Double"

        case date = "Date"

        case data = "Data"

        case nilValue = "Nil"

        case entity = "Entity"
        case array = "Array"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)

        try container.encode(string, forKey: .string)

        try container.encode(int, forKey: .int)
        try container.encode(int8, forKey: .int8)
        try container.encode(int16, forKey: .int16)
        try container.encode(int32, forKey: .int32)
        try container.encode(int64, forKey: .int64)
        try container.encode(uInt, forKey: .uInt)
        try container.encode(uInt8, forKey: .uInt8)
        try container.encode(uInt16, forKey: .uInt16)
        try container.encode(uInt32, forKey: .uInt32)
        try container.encode(uInt64, forKey: .uInt64)

        try container.encode(float, forKey: .float)
        try container.encode(double, forKey: .double)

        try container.encode(date, forKey: .date)

        try container.encode(data, forKey: .data)

        try container.encodeNil(forKey: .nilValue)

        try container.encode(entity, forKey: .entity)
        try container.encode(array, forKey: .array)
    }
}
