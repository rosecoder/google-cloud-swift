import GCPTrace
import RediStack
import Logging
import Foundation

extension Redis {

    public static func get(key: Key, trace: Trace?) async throws -> RESPValue {
        try await trace.recordSpan(named: "redis-get", attributes: [
            "redis/key": key.rawValue,
        ]) { span in
            try await connection.get(key).get()
        }
    }

    public static func get<Element>(
        _ type: Element.Type,
        key: Key,
        trace: Trace?
    ) async throws -> Element?
    where Element: Codable
    {
        let value = try await get(key: key, trace: trace)
        guard let byteBuffer = value.byteBuffer else {
            return nil
        }
        return try defaultDecoder.decode(type, from: byteBuffer)
    }

    public static func get<Element>(
        _ type: Element.Type,
        key: Key,
        or fallback: () async throws -> Element,
        trace: Trace?
    ) async throws -> Element
    where Element: Codable
    {
        let value = try await get(key: key, trace: trace)
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
        trace: Trace?
    ) async throws -> Element
    where Element: Codable
    {
        let value = try await get(key: key, trace: trace)
        if
            let byteBuffer = value.byteBuffer,
            let result = try? defaultDecoder.decode(type, from: byteBuffer)
        {
            return result
        }

        let result = try await fallback()

        Task {
            do {
                try await Self.set(key: key, to: result, trace: trace)
            } catch {
                let logger = Logger(label: "redis")
                logger.error("Failed to set fallback value: \(error)")
            }
        }

        return result
    }
}
