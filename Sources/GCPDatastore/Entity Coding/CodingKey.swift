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
