import Foundation

public struct SwiftyTranslation {
    /**
     The class for the google translator
     */
    public class TranslatorEngine {
        var apiKey : String?
        var projectId : String?
        
        /**
         Creates a TranslatorEngine object for translation.
         */
        public init(apiKey: String?, projectId : String?) throws {
            if apiKey == nil {
                throw TranslatorEngineInitalizationError.apiKeyNil
            } else if projectId == nil {
                throw TranslatorEngineInitalizationError.projectIdNil
            }
            self.apiKey = apiKey
            self.projectId = projectId
        }
    }
    
    public enum API: String {
        case translate = "https://translation.googleapis.com/language/translate/v2?q={{TEXT}}&target={{TARGET}}"
        case detect = "Detect"
        case supportedLangs = "Supported Languages"
    }
    
    enum TranslatorEngineInitalizationError: Error {
        case apiKeyNil
        case projectIdNil
    }
    enum translationError: Error {
        case responseTextNil
    }
}
