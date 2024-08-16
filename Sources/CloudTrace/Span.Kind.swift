import Foundation

extension Span {

    public enum Kind: Sendable, Hashable, Codable {

        /// Indicates that the span is used internally.
        case `internal`

        /// Indicates that the span covers server-side handling of an RPC or other
        /// remote network request.
        case server

        /// Indicates that the span covers the client-side wrapper around an RPC or
        /// other remote request.
        case client

        /// Indicates that the span describes producer sending a message to a broker.
        /// Unlike client and  server, there is no direct critical path latency
        /// relationship between producer and consumer spans (e.g. publishing a
        /// message to a pubsub service).
        case producer

        /// Indicates that the span describes consumer receiving a message from a
        /// broker. Unlike client and  server, there is no direct critical path
        /// latency relationship between producer and consumer spans (e.g. receiving
        /// a message from a pubsub service subscription).
        case consumer
    }
}
