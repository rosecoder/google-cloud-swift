import CloudCore
import CloudApp
import ArgumentParser
import ServiceLifecycle
import ServiceContextModule
import RetryableTask
import Logging
import Tracing

public struct ArgumentParserService<Command: AsyncParsableCommand>: Service {

    let command: Command.Type

    public func run() async throws {
        await DefaultRetryPolicyConfiguration.shared.use(retryPolicy: ExponentialBackoffDelayRetryPolicy(
            minimumBackoffDelay: 200_000_000, // 200 ms
            maximumBackoffDelay: 5_000_000_000, // 5 000 ms
            maxRetries: 7
        ))

        try await withSpan(command._commandName, ofKind: .internal) { span in
            var command = try command.parseAsRoot(nil)
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.run()
            } else {
                try command.run()
            }
            span.setStatus(SpanStatus(code: .ok))
        }
    }
}
