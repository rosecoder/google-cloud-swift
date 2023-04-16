import XCTest
@testable import GCPApp

final class GRPCDependencyTests: XCTestCase {

    func testAddressParsing() {
        // Test valid address with port
        let address = "https://example.com:8080"
        do {
            let components = try address.parsedAddressComponents()
            XCTAssertEqual(components.scheme, "https")
            XCTAssertEqual(components.host, "example.com")
            XCTAssertEqual(components.port, 8080)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }

        // Test valid address without port
        let address2 = "http://localhost"
        do {
            let components = try address2.parsedAddressComponents()
            XCTAssertEqual(components.scheme, "http")
            XCTAssertEqual(components.host, "localhost")
            XCTAssertNil(components.port)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }

        // Test invalid address with missing scheme
        let address3 = "example.com"
        do {
            _ = try address3.parsedAddressComponents()
            XCTFail("Expected error to be thrown")
        } catch GRPCDependencyBootstrapError.serviceSchemeNotFound {
            // Test passed
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }

        // Test invalid address with invalid port
        let address4 = "http://localhost:abc"
        do {
            _ = try address4.parsedAddressComponents()
            XCTFail("Expected error to be thrown")
        } catch GRPCDependencyBootstrapError.invalidServicePort(let port) {
            XCTAssertEqual(port, "abc")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}
