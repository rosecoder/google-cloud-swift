import XCTest
@testable import CloudStorage

class EmulatorTestCase: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()

        try await Storage.shared.bootstrapForDebug()
    }
}
