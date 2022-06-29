import Foundation
import Logging
import GCPCore

extension Logger {

    public mutating func addMetadata(for trace: Trace) {
#if !DEBUG
        self[metadataKey: LogMetadataKeys.trace] = .string("projects/\(Tracing.projectID)/traces/\(trace.id.stringValue)")
        if let spanID = trace.spanID ?? trace.rootSpan?.id {
            self[metadataKey: LogMetadataKeys.spanID] = .string(spanID.stringValue)
        }
#endif
    }
}
