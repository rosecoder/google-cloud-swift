import CloudTrace
@preconcurrency import RediStack
import Logging
import Foundation

extension Redis {

    public static func get(key: Key, context: Context) async throws -> RESPValue {
        try await shared.ensureConnection(context: context)
        return try await context.trace.recordSpan(named: "redis-get", kind: .client, attributes: [
            "redis/key": key.rawValue,
        ]) { span in
            try await shared.connection.get(key).get()
        }
    }

    public static func get<Element>(
        _ type: Element.Type,
        key: Key,
        context: Context
    ) async throws -> Element?
    where Element: Codable
    {
        let value = try await get(key: key, context: context)
        guard let byteBuffer = value.byteBuffer else {
            return nil
        }
        return try defaultDecoder.decode(type, from: byteBuffer)
    }

    public static func get<Element>(
        _ type: Element.Type,
        key: Key,
        or fallback: () async throws -> Element,
        context: Context
    ) async throws -> Element
    where Element: Codable
    {
        let value = try await get(key: key, context: context)
        if
            let byteBuffer = value.byteBuffer,
            let result = try? defaultDecoder.decode(type, from: byteBuffer)
        {
            return result
        }
        return try await fallback()
    }

    public static func get<Element>(
        _ type: Element.Type,
        key: Key,
        orAndSet fallback: () async throws -> Element,
        context: Context
    ) async throws -> Element
    where Element: Codable
    {
        let value = try await get(key: key, context: context)
        if
            let byteBuffer = value.byteBuffer,
            let result = try? defaultDecoder.decode(type, from: byteBuffer)
        {
            return result
        }

        let result = try await fallback()

        Task {
            do {
                try await Redis.set(key: key, to: result, context: context)
            } catch {
                let logger = Logger(label: "redis")
                logger.error("Failed to set fallback value: \(error)")
            }
        }

        return result
    }
}
