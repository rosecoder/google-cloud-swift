import CloudCore
import CloudApp
import ArgumentParser

public typealias DependencyOptions = CloudApp.DependencyOptions

public protocol App: CloudApp.App, AsyncParsableCommand {

    static var commands: [Command.Type] { get }
}

// MARK: - Default implementations

extension App {

    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            version: Environment.current.version ?? "",
            subcommands: commands
        )
    }
}
