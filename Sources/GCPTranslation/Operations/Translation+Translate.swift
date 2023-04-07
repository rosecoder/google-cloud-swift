import Foundation
import GCPTrace

extension Translation {

    public enum MimeType {
        case plainText
        case html

        fileprivate var rawValue: String {
            switch self {
            case .plainText:
                return "text/plain"
            case .html:
                return "text/html"
            }
        }
    }

    public struct TranslationResult {

        public let translatedText: String
        public let sourceLanguageCode: String
    }

    public static func translate(
        contents: [String],
        mimeType: MimeType,
        from sourceLanguageCode: String? = nil,
        to targetLanguageCode: String,
        labels: [String: String]? = nil,
        context: Context
    ) async throws -> [TranslationResult] {
        try await client.ensureAuthentication(authorization: authorization, context: context, traceContext: "translation")

        let response: Google_Cloud_Translation_V3_TranslateTextResponse = try await context.trace.recordSpan(named: "translation-translate", kind: .client) { span in
            try await client.translateText(.with {
                $0.contents = contents
                $0.mimeType = mimeType.rawValue
                if let sourceLanguageCode {
                    $0.sourceLanguageCode = sourceLanguageCode
                }
                $0.targetLanguageCode = targetLanguageCode
                $0.parent = "projects/" + ProcessInfo.processInfo.environment["GCP_PROJECT_ID"]! // TODO: remove force unwrap
                if let labels {
                    $0.labels = labels
                }
            })
        }

        return response.translations.map { translation in
            TranslationResult(
                translatedText: translation.translatedText,
                sourceLanguageCode: sourceLanguageCode ?? translation.detectedLanguageCode
            )
        }
    }

    public static func translate(
        content: String,
        mimeType: MimeType,
        from sourceLanguageCode: String? = nil,
        to targetLanguageCode: String,
        labels: [String: String]? = nil,
        context: Context
    ) async throws -> TranslationResult {
        try await translate(contents: [content], mimeType: mimeType, from: sourceLanguageCode, to: targetLanguageCode, labels: labels, context: context)[0]
    }
}
