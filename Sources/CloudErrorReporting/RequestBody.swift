import Foundation

/// For more detailed documentation for each field, see: https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
struct RequestBody: Encodable {

    let eventTime: String
    let serviceContext: ServiceContext
    let message: String
    let context: Context

    struct ServiceContext: Encodable {

        let service: String
        let version: String
    }

    struct Context: Encodable {

        let httpRequest: HTTPRequest?
        let user: String?
        let reportLocation: ReportLocation
        let sourceReferences: [SourceReference]?
    }

    struct HTTPRequest: Encodable {

        let method: String?
        let url: String?
        let userAgent: String?
        let referrer: String?
        let responseStatusCode: UInt?
        let remoteIp: String?
    }

    struct ReportLocation: Encodable {

        let filePath: String
        let lineNumber: UInt
        let functionName: String
    }

    struct SourceReference: Encodable {

        let repository: String
        let revisionId: String
    }

    // MARK: - Utilities

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()
}
