import Logging

extension Google_Logging_Type_LogSeverity {

    init(level: Logger.Level) {
        switch level {
        case .trace:
            self = .default
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .notice:
            self = .notice
        case .warning:
            self = .warning
        case .error:
            self = .error
        case .critical:
            self = .critical
        }
    }
}
