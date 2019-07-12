//
//  TranslatorEngine.swift
//  Just
//
//  Created by Noah Scott on 7/11/19.
//

import Foundation

public struct SwiftyTranslation {
    /**
     The class for the Google Translator Engine
     */
    public class TranslatorEngine {
        var apiKey : String?
        
        /**
         Creates a TranslatorEngine object for translation.
         */
        public init(apiKey: String?) throws {
            if apiKey == nil {
                throw TranslatorEngineInitalizationError.apiKeyNil
            }
            self.apiKey = apiKey
        }
    }
    
    public enum API: String {
        case translate = "https://translation.googleapis.com/language/translate/v2?q={{TEXT}}&target={{TARGET}}&key={{KEY}}"
        case detect = "https://translation.googleapis.com/language/translate/v2/detect?q={{TEXT}}&key={{KEY}}"
        case supportedLangs = "Supported Languages"
    }
    
    enum TranslatorEngineInitalizationError: Error {
        case apiKeyNil
    }
    enum networkError: Error {
        case responseNil
    }
}
