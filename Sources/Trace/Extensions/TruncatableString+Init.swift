import Foundation

extension Google_Devtools_Cloudtrace_V2_TruncatableString {

    init(_ string: String, limit: Int) {
        self.init()

        if string.utf8.count <= limit {
            self.value = string
            self.truncatedByteCount = 0
        } else {
            var limit = limit

            // TODO: Investigate, is this really the best way of truncating a Swift string by bytes count?

            var value: String?
            while value == nil {
                value = String(string.utf8[string.utf8.startIndex..<string.utf8.index(string.utf8.startIndex, offsetBy: limit)])

                limit -= 1
                assert(limit != 0)
            }

            self.value = value!
            self.truncatedByteCount = Int32(string.utf8.count - value!.utf8.count)
        }
    }
}
