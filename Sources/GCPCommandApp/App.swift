import GCPCore
import GCPApp
import ArgumentParser

public typealias DependencyOptions = GCPApp.DependencyOptions

public protocol App: GCPApp.App, AsyncParsableCommand {

    static var commands: [Command.Type] { get }
}

// MARK: - Default implementations

extension App {

    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            version: Resource.version ?? "",
            subcommands: commands
        )
    }
}
