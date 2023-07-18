import Logging
import CloudTrace

struct CommandContext: Context {

    var logger: Logger
    var trace: Trace?

    init(name: String) {
        self.trace = Trace(named: name, kind: .consumer)
        self.logger = Logger(label: name, trace: trace)
    }
}
