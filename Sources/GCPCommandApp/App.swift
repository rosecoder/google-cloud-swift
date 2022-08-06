import GCPCore
import GCPApp
import ArgumentParser

public typealias DependencyOptions = GCPApp.DependencyOptions
public typealias Command = ArgumentParser.AsyncParsableCommand

public protocol App: GCPApp.App, AsyncParsableCommand {

    static var commands: [Command.Type] { get }
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
