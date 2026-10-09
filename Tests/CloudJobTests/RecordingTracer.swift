import Synchronization
import Tracing

final class RecordingTracer: Tracer {

    static let bootstrapped: RecordingTracer = {
        let tracer = RecordingTracer()
        InstrumentationSystem.bootstrap(tracer)
        return tracer
    }()

    private let recordedSpans = Mutex<[RecordingSpan]>([])

    var spans: [RecordingSpan] {
        recordedSpans.withLock { $0 }
    }

    func startSpan<Instant: TracerInstant>(
        _ operationName: String,
        context: @autoclosure () -> ServiceContext,
        ofKind kind: SpanKind,
        at instant: @autoclosure () -> Instant,
        function: String,
        file fileID: String,
        line: UInt
    ) -> RecordingSpan {
        let span = RecordingSpan(operationName: operationName, context: context())
        recordedSpans.withLock { $0.append(span) }
        return span
    }

    func forceFlush() {}

    func extract<Carrier, Extract>(_ carrier: Carrier, into context: inout ServiceContext, using extractor: Extract)
    where Extract: Extractor, Carrier == Extract.Carrier {}

    func inject<Carrier, Inject>(_ context: ServiceContext, into carrier: inout Carrier, using injector: Inject)
    where Inject: Injector, Carrier == Inject.Carrier {}
}

final class RecordingSpan: Span {

    private struct State {
        var operationName: String
        var attributes = SpanAttributes()
        var status: SpanStatus?
        var recordedErrors: [any Error] = []
        var isEnded = false
    }

    let context: ServiceContext
    private let state: Mutex<State>

    init(operationName: String, context: ServiceContext) {
        self.context = context
        self.state = Mutex(State(operationName: operationName))
    }

    var operationName: String {
        get { state.withLock { $0.operationName } }
        set { state.withLock { $0.operationName = newValue } }
    }

    var attributes: SpanAttributes {
        get { state.withLock { $0.attributes } }
        set { state.withLock { $0.attributes = newValue } }
    }

    var status: SpanStatus? {
        state.withLock { $0.status }
    }

    var recordedErrors: [any Error] {
        state.withLock { $0.recordedErrors }
    }

    var isEnded: Bool {
        state.withLock { $0.isEnded }
    }

    var isRecording: Bool {
        !isEnded
    }

    func setStatus(_ status: SpanStatus) {
        state.withLock { $0.status = status }
    }

    func addEvent(_ event: SpanEvent) {}

    func addLink(_ link: SpanLink) {}

    func recordError<Instant: TracerInstant>(
        _ error: Error,
        attributes: SpanAttributes,
        at instant: @autoclosure () -> Instant
    ) {
        state.withLock { $0.recordedErrors.append(error) }
    }

    func end<Instant: TracerInstant>(at instant: @autoclosure () -> Instant) {
        state.withLock { $0.isEnded = true }
    }
}
