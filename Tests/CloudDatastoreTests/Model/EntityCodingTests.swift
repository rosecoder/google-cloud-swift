import XCTest
@testable import CloudDatastore

final class EntityCodingTests: XCTestCase {

    private let encoder = EntityEncoder()
    private let decoder = EntityDecoder()

    // MARK: - Coding Property Configuration

    func testCodingPropertyConfiguration() throws {
        let source = entity(key: .incomplete)

        let raw = try encoder.encode(source)

        let stringProperty = try XCTUnwrap(raw.properties["String"])
        let intProperty = try XCTUnwrap(raw.properties["Int"])

        XCTAssertTrue(stringProperty.excludeFromIndexes)
        XCTAssertFalse(intProperty.excludeFromIndexes)
        assert(raw: raw, matching: source)
    }

    // MARK: - Coding Properties

    func testWithIncompleteKey() throws {
        let source = entity(key: .incomplete)

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "")
        XCTAssertEqual(raw.key.path.count, 1)
        XCTAssertEqual(raw.key.path.first?.kind, AllPropertyTypeEntity.Key.kind)
        XCTAssertEqual(raw.key.path.first?.idType, nil)
        assert(raw: raw, matching: source)

        let entity = try decoder.decode(AllPropertyTypeEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    func testWithIDKey() throws {
        let source = entity(key: .uniq(1))

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "")
        XCTAssertEqual(raw.key.path.count, 1)
        XCTAssertEqual(raw.key.path.first?.kind, AllPropertyTypeEntity.Key.kind)
        XCTAssertEqual(raw.key.path.first?.id, 1)
        assert(raw: raw, matching: source)

        let entity = try decoder.decode(AllPropertyTypeEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    func testWithNamedKey() throws {
        let source = entity(key: .named("abc"))

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "")
        XCTAssertEqual(raw.key.path.count, 1)
        XCTAssertEqual(raw.key.path.first?.kind, AllPropertyTypeEntity.Key.kind)
        XCTAssertEqual(raw.key.path.first?.name, "abc")
        assert(raw: raw, matching: source)

        let entity = try decoder.decode(AllPropertyTypeEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    // MARK: - Coding Keys

    func testWithIndependentKey() throws {
        let source = IndependentKeyEntity(key: .named("c"))

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "")
        XCTAssertEqual(raw.key.path.count, 1)
        XCTAssertEqual(raw.key.path.first?.kind, IndependentKeyEntity.Key.kind)
        XCTAssertEqual(raw.key.path.first?.name, "c")

        let entity = try decoder.decode(IndependentKeyEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    func testWithIndependentNamespaceableKey() throws {
        let source = IndependentNamespaceableKeyEntity(key: .named("c", namespace: .test1))

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "test1")
        XCTAssertEqual(raw.key.path.count, 1)
        XCTAssertEqual(raw.key.path.first?.kind, IndependentNamespaceableKeyEntity.Key.kind)
        XCTAssertEqual(raw.key.path.first?.name, "c")

        let entity = try decoder.decode(IndependentNamespaceableKeyEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    func testWithParentableKey() throws {
        let source = ParentableKeyEntity(key: .named("c", parent: .named("p")))

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "")
        XCTAssertEqual(raw.key.path.count, 2)
        XCTAssertEqual(raw.key.path.first?.kind, ParentableKeyEntity.Key.Parent.kind)
        XCTAssertEqual(raw.key.path.first?.name, "p")
        XCTAssertEqual(raw.key.path.last?.kind, ParentableKeyEntity.Key.kind)
        XCTAssertEqual(raw.key.path.last?.name, "c")

        let entity = try decoder.decode(ParentableKeyEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    func testWithParentableNamespaceableKey() throws {
        let source = ParentableNamespaceableKeyEntity(key: .named("c", parent: .named("p", namespace: .test1), namespace: .test1))

        let raw = try encoder.encode(source)
        XCTAssertEqual(raw.key.partitionID.namespaceID, "test1")
        XCTAssertEqual(raw.key.path.count, 2)
        XCTAssertEqual(raw.key.path.first?.kind, ParentableNamespaceableKeyEntity.Key.Parent.kind)
        XCTAssertEqual(raw.key.path.first?.name, "p")
        XCTAssertEqual(raw.key.path.last?.kind, ParentableNamespaceableKeyEntity.Key.kind)
        XCTAssertEqual(raw.key.path.last?.name, "c")

        let entity = try decoder.decode(ParentableNamespaceableKeyEntity.self, from: raw)
        XCTAssertEqual(entity, source)
    }

    // MARK: -

    private func entity(key: AllPropertyTypeEntity.Key) -> AllPropertyTypeEntity {
        AllPropertyTypeEntity(
            key: key,

            string: "test",

            int: 5,
            int8: 6,
            int16: 7,
            int32: 8,
            int64: 9,
            uInt: 10,
            uInt8: 11,
            uInt16: 12,
            uInt32: 13,
            uInt64: 14,

            float: 0.5,
            double: 1.32,

            date: Date(timeIntervalSince1970: 1),

            data: Data([1, 2, 3]),

            nilValue: nil,

            entity: User(key: .incomplete, email: "testing"),
            array: ["a", "b", "c", "z"],
            dictionary: ["a": 1, "b": 2, "c": 3]
        )
    }

    private func assert(raw: Google_Datastore_V1_Entity, matching entity: AllPropertyTypeEntity, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(
            raw.properties["String"]?.stringValue,
            entity.string,
            "Property string was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Int"]?.integerValue,
            Int64(entity.int),
            "Property int was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Int8"]?.integerValue,
            Int64(entity.int8),
            "Property int8 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Int16"]?.integerValue,
            Int64(entity.int16),
            "Property int16 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Int32"]?.integerValue,
            Int64(entity.int32),
            "Property int32 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Int64"]?.integerValue,
            entity.int64,
            "Property int64 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["UInt"]?.integerValue,
            Int64(entity.uInt),
            "Property uInt was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["UInt8"]?.integerValue,
            Int64(entity.uInt8),
            "Property uInt8 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["UInt16"]?.integerValue,
            Int64(entity.uInt16),
            "Property uInt16 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["UInt32"]?.integerValue,
            Int64(entity.uInt32),
            "Property uInt32 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["UInt64"]?.integerValue,
            Int64(entity.uInt64),
            "Property uInt64 was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Float"]?.doubleValue,
            Double(entity.float),
            "Property float was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Double"]?.doubleValue,
            entity.double,
            "Property double was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Date"]?.timestampValue.date,
            entity.date,
            "Property date was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Data"]?.blobValue,
            entity.data,
            "Property data was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Nil"]?.valueType,
            .nullValue(.nullValue),
            "Property nilValue was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Entity"]?.entityValue.properties["Email"]?.valueType,
            .stringValue("testing"),
            "Property entity was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Array"]?.arrayValue.values.first?.valueType,
            .stringValue("a"),
            "Property array.first was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Array"]?.arrayValue.values.last?.valueType,
            .stringValue("z"),
            "Property array.last was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Dictionary"]?.entityValue.properties["a"]?.valueType,
            .integerValue(1),
            "Property dictionary.a was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Dictionary"]?.entityValue.properties["b"]?.valueType,
            .integerValue(2),
            "Property dictionary.b was not encoded correctly",
            file: file,
            line: line
        )
        XCTAssertEqual(
            raw.properties["Dictionary"]?.entityValue.properties["c"]?.valueType,
            .integerValue(3),
            "Property dictionary.c was not encoded correctly",
            file: file,
            line: line
        )
    }
}
