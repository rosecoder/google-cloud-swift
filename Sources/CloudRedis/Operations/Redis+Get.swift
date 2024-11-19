@preconcurrency import RediStack
import Logging
import Tracing
import Foundation

extension Redis {

    public func get(key: Key) async throws -> RESPValue {
        let connection = try await ensureConnection()
        return try await withSpan("redis-get", ofKind: .client) { span in
            span.attributes["redis/key"] = key.rawValue
            return try await connection.get(key).get()
        }
    }

    public func get<Element>(
        _ type: Element.Type,
        key: Key
    ) async throws -> Element?
    where Element: Codable
    {
        let value = try await get(key: key)
        guard let byteBuffer = value.byteBuffer else {
            return nil
        }
        return try defaultDecoder.decode(type, from: byteBuffer)
    }

    public func get<Element>(
        _ type: Element.Type,
        key: Key,
        or fallback: () async throws -> Element
    ) async throws -> Element
    where Element: Codable,
          Element: Sendable
    {
        let value = try await get(key: key)
        if
            let byteBuffer = value.byteBuffer,
            let result = try? defaultDecoder.decode(type, from: byteBuffer)
        {
            return result
        }
        return try await fallback()
    }

    public func get<Element>(
        _ type: Element.Type,
        key: Key,
        orAndSet fallback: () async throws -> Element
    ) async throws -> Element
    where Element: Codable,
          Element: Sendable
    {
        let value = try await get(key: key)
        if
            let byteBuffer = value.byteBuffer,
            let result = try? defaultDecoder.decode(type, from: byteBuffer)
        {
            return result
        }

        let result = try await fallback()

        Task {
            do {
                try await self.set(key: key, to: result)
            } catch {
                let logger = Logger(label: "redis")
                logger.error("Failed to set fallback value: \(error)")
            }
        }

        return result
    }
}
