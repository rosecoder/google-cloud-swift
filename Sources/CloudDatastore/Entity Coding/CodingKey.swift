struct IndexKey: CodingKey {

    let index: Int

    init(_ index: Int) {
        self.index = index
    }

    init?(intValue: Int) {
        self.init(intValue)
    }

    init?(stringValue: String) {
        guard let intValue = Int(stringValue) else {
            return nil
        }
        self.init(intValue)
    }

    var stringValue: String {
        String(self.index)
    }

    var intValue: Int? {
        self.index
    }
}

struct NameKey: CodingKey {

    let name: String

    init(_ stringValue: String) {
        self.name = stringValue
    }

    init?(intValue: Int) {
        self.init(String(intValue))
    }

    init?(stringValue: String) {
        self.init(stringValue)
    }

    var stringValue: String {
        name
    }

    var intValue: Int? {
        Int(name)
    }
}
