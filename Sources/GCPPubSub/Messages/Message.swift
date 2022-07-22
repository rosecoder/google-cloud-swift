import Foundation
import GCPTrace

public protocol Message {

    associatedtype Incoming
    associatedtype Outgoing
}

// MARK: - Outgoing

public protocol OutgoingMessage {

    var data: Data { get }
    var attributes: [String: String] { get }
}

// MARK: - Incoming

public protocol IncomingMessage {

    var id: String { get }
    var published: Date { get }

    init(id: String, published: Date, data: Data, attributes: [String: String], context: inout Context) throws
}

#if DEBUG
extension IncomingMessage {

    public init(
        data: Data,
        attributes: [String: String] = [:]
    ) throws {
        var context: Context = TestContext()
        try self.init(id: "0", published: Date(), data: data, attributes: attributes, context: &context)
    }
}
#endif

