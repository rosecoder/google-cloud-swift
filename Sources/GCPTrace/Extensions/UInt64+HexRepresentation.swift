extension UInt64 {

    var prefixedHexRepresentation: String {
        let string = String(self, radix: 16, uppercase: false)
        return String(repeating: "0", count: 16 - string.count) + string
    }
}
