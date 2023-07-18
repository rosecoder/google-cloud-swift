import XCTest
import CloudTranslation
import CloudTrace

final class TranslateTests: EmulatorTestCase {

    func testTranslateText() async throws {
        let result = try await Translation.translate(content: "Hello world!", mimeType: .plainText, to: "sv", context: context)
        XCTAssertEqual(result.translatedText, "Hej världen!")
        XCTAssertEqual(result.sourceLanguageCode, "en")
    }
}
