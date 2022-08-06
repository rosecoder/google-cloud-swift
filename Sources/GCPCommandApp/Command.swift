import ArgumentParser
import GCPTrace

public protocol Command: ArgumentParser.AsyncParsableCommand {

    var context: Context { get set }

    mutating func execute() async throws
}

private var _context: Context?

extension Command {

    public var context: Context {
        get {
            if _context == nil {
                _context = CommandContext(name: Self._commandName)
            }
            return _context!
        }
        set {
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
            commandApp!.terminate(exitCode: ExitCode.failure.rawValue)
        }
    }
}
