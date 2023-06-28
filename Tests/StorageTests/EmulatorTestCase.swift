import XCTest
@testable import Storage

class EmulatorTestCase: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()

        try await Storage.bootstrapForDebug()
    }
}
