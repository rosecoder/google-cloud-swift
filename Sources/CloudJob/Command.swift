import ArgumentParser
import CloudTrace
import Foundation

public protocol Command: ArgumentParser.AsyncParsableCommand {

    var context: Context { get set }

    mutating func execute() async throws
}

private nonisolated(unsafe) var _context: Context?
private let contextLock = NSLock()

extension Command {

    public var context: Context {
        get {
            contextLock.lock()
            defer { contextLock.unlock() }

            if _context == nil {
                _context = CommandContext(name: Self._commandName)
            }
            return _context!
        }
        set {
            contextLock.lock()
            defer { contextLock.unlock() }

            _context = newValue
        }
    }

    public mutating func run() async throws {
        do {
            try await execute()

            context.trace?.end(statusCode: .ok)
        } catch {
            context.trace?.end(error: error)
            context.logger.error("\(error)")
            await commandApp!.terminate(exitCode: ExitCode.failure.rawValue)
        }
    }
}
