import Testing
import ArgumentParser
import Logging
import ServiceLifecycle
import Synchronization
import Tracing
@testable import CloudJob

@Suite(.serialized)
struct CommandServiceTests {

    @Test func failingCommandShutsDownGroupGracefullyAndRethrows() async throws {
        let probe = ProbeService()
        let group = makeGroup(services: [
            .init(service: probe),
            .command(FailingCommand.self, arguments: []),
        ])

        await #expect(throws: CommandError.self) {
            try await group.run()
        }
        #expect(probe.outcome == .gracefullyShutDown(flushed: true))
    }

    @Test func succeedingCommandShutsDownGroupGracefully() async throws {
        let probe = ProbeService()
        let group = makeGroup(services: [
            .init(service: probe),
            .command(SucceedingCommand.self, arguments: []),
        ])

        try await group.run()

        #expect(probe.outcome == .gracefullyShutDown(flushed: true))
    }

    @Test func failingCommandWithoutHelperCancelsGroup() async throws {
        let probe = ProbeService()
        let group = makeGroup(services: [
            .init(service: probe),
            .init(
                service: ArgumentParserService(command: FailingCommand.self, arguments: []),
                successTerminationBehavior: .gracefullyShutdownGroup
            ),
        ])

        await #expect(throws: CommandError.self) {
            try await group.run()
        }
        #expect(probe.outcome == .cancelled)
    }

    @Test func failingCommandRecordsErrorOnSpan() async throws {
        let tracer = RecordingTracer.bootstrapped

        await #expect(throws: CommandError.self) {
            try await ArgumentParserService(command: FailingCommand.self, arguments: []).run()
        }

        let span = try #require(tracer.spans.last { $0.operationName == "failing" })
        #expect(span.status?.code == .error)
        #expect(span.recordedErrors.count == 1)
        #expect(span.recordedErrors.first is CommandError)
        #expect(span.isEnded)
    }

    @Test func succeedingCommandSetsOkStatusOnSpan() async throws {
        let tracer = RecordingTracer.bootstrapped

        try await ArgumentParserService(command: SucceedingCommand.self, arguments: []).run()

        let span = try #require(tracer.spans.last { $0.operationName == "succeeding" })
        #expect(span.status?.code == .ok)
        #expect(span.recordedErrors.isEmpty)
    }

    private func makeGroup(services: [ServiceGroupConfiguration.ServiceConfiguration]) -> ServiceGroup {
        ServiceGroup(configuration: ServiceGroupConfiguration(
            services: services,
            logger: Logger(label: "test")
        ))
    }
}

struct CommandError: Error {}

struct FailingCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(commandName: "failing")

    func run() async throws {
        throw CommandError()
    }
}

struct SucceedingCommand: AsyncParsableCommand {

    static let configuration = CommandConfiguration(commandName: "succeeding")

    func run() async throws {}
}

/// Stands in for a telemetry service which exports its final batch on graceful shutdown.
final class ProbeService: Service {

    enum Outcome: Equatable, Sendable {
        case gracefullyShutDown(flushed: Bool)
        case cancelled
    }

    private let state = Mutex<Outcome?>(nil)

    var outcome: Outcome? {
        state.withLock { $0 }
    }

    func run() async throws {
        do {
            try await gracefulShutdown()
        } catch {
            state.withLock { $0 = .cancelled }
            return
        }
        let flushed = (try? await Task.sleep(for: .milliseconds(20))) != nil
        state.withLock { $0 = .gracefullyShutDown(flushed: flushed) }
    }
}
