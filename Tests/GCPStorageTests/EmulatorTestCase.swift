import XCTest
@testable import GCPStorage

class EmulatorTestCase: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()

        try await Storage.bootstrapForDebug()
    }
}