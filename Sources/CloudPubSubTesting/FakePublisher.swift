import CloudPubSub
import Synchronization

public final class FakePublisher: PublisherProtocol {

    public init() {}

    private let _publishedCount = Mutex<Int>(0)

    public var publishedCount: Int {
        _publishedCount.withLock { $0 }
    }

    @discardableResult
    public func publish<Message>(
        to topic: Topic<Message>,
        messages: [Message.Outgoing],
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) async throws -> [PublishedMessage] {
        guard !messages.isEmpty else {
            return []
        }

        let maxID = _publishedCount.withLock {
            $0 += messages.count
            return $0
        }
        return messages.indices.map {
            PublishedMessage(id: String(maxID - $0))
        }
    }
}
