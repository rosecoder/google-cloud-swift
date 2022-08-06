import GCPCore
import GCPApp
import ArgumentParser

public protocol App: GCPApp.App, AsyncParsableCommand {

    static var commands: [ParsableCommand.Type] { get }
}

// MARK: - Default implementations

extension App {

    static var configuration: CommandConfiguration {
        CommandConfiguration(
            version: Resource.version ?? "",
            subcommands: commands
        )
    }
}
