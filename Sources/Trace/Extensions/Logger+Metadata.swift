import Foundation
import Logging
import CloudCore

extension Logger {

    public init(label: String, trace: Trace?) {
        self.init(label: label)

        if let trace = trace {
            addMetadata(for: trace)
        }
    }

    public mutating func addMetadata(for trace: Trace) {
#if !DEBUG
        self[metadataKey: LogMetadataKeys.trace] = .string("projects/\(Tracing.projectID)/traces/\(trace.id.stringValue)")
        self[metadataKey: LogMetadataKeys.spanID] = .string(trace.spanID.stringValue)
#endif
    }
}
