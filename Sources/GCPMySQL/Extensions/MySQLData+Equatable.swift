import MySQLNIO

extension MySQLData: Equatable {

    public static func == (lhs: MySQLData, rhs: MySQLData) -> Bool {
        lhs.type == rhs.type && lhs.isUnsigned == rhs.isUnsigned && lhs.buffer == rhs.buffer
    }
}
