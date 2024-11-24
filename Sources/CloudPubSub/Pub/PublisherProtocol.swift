public protocol PublisherProtocol: Sendable {
    
    @discardableResult
    func publish<Message>(
        to topic: Topic<Message>,
        messages: [Message.Outgoing],
        file: String,
        function: String,
        line: UInt
    ) async throws -> [PublishedMessage]
}

extension PublisherProtocol {

    @discardableResult
    public func publish<Message>(
        to topic: Topic<Message>,
        messages: [Message.Outgoing],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [PublishedMessage] {
        try await publish(to: topic, messages: messages, file: file, function: function, line: line)
    }

    @discardableResult
    public func publish<Message>(
        to topic: Topic<Message>,
        message: Message.Outgoing,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> PublishedMessage {
        (try await publish(to: topic, messages: [message], file: file, function: function, line: line))[0]
    }
}
