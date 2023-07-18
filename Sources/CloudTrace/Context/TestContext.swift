#if DEBUG
import XCTest
import Logging

/// Context that can be used in tests.
///
/// Note: `TestContext` is only avaiable when compiling for DEBUG.
public struct TestContext: Context {

    public var logger: Logger
    public var trace: Trace?

    public init() {
        self.logger = Logger(label: "test")
        self.trace = nil
    }
}

extension XCTest {

    public var context: Context { TestContext() }
}

#endif
