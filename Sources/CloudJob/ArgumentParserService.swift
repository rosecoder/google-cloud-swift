import CloudCore
import CloudApp
import ArgumentParser
import ServiceLifecycle
import ServiceContextModule
import RetryableTask
import Logging
import Tracing

extension ServiceGroupConfiguration.ServiceConfiguration {

    /// Runs the command and gracefully shuts down the service group when it finishes, whether it succeeds or fails, so
    /// telemetry of failed runs is still exported. The command's error is rethrown by the service group, so the
    /// process still exits with a non-zero status.
    public static func command<Command: AsyncParsableCommand>(_ command: Command.Type) -> Self {
        self.command(command, arguments: nil)
    }

    static func command<Command: AsyncParsableCommand>(_ command: Command.Type, arguments: [String]?) -> Self {
        .init(
            service: ArgumentParserService(command: command, arguments: arguments),
            successTerminationBehavior: .gracefullyShutdownGroup,
            failureTerminationBehavior: .gracefullyShutdownGroup
        )
    }
}

public struct ArgumentParserService<Command: AsyncParsableCommand>: Service {

    let command: Command.Type
    let arguments: [String]?

    public init(command: Command.Type) {
        self.init(command: command, arguments: nil)
    }

    init(command: Command.Type, arguments: [String]?) {
        self.command = command
        self.arguments = arguments
    }

    public func run() async throws {
        await DefaultRetryPolicyConfiguration.shared.use(retryPolicy: ExponentialBackoffDelayRetryPolicy(
            minimumBackoffDelay: 200_000_000, // 200 ms
            maximumBackoffDelay: 5_000_000_000, // 5 000 ms
            maxRetries: 7
        ))

        try await withSpan(command._commandName, ofKind: .internal) { span in
            do {
                var command = try command.parseAsRoot(arguments)
                if var asyncCommand = command as? AsyncParsableCommand {
                    try await asyncCommand.run()
                } else {
                    try command.run()
                }
                span.setStatus(SpanStatus(code: .ok))
            } catch {
                span.setStatus(SpanStatus(code: .error, message: "\(error)"))
                Logger(label: "argument-parser-service").error("Error running command: \(error)")
                throw error
            }
        }
    }
}
