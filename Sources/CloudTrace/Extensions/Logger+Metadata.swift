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
        let traceString = trace.id.stringValue
        let spanString = trace.spanID.stringValue
#if DEBUG
        // ignore unused warnings
         _ = traceString
        _ = spanString
#else
        self[metadataKey: LogMetadataKeys.traceID] = .string(traceString)
        self[metadataKey: LogMetadataKeys.spanID] = .string(spanString)
#endif
    }
}
