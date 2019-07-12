//
//  TranslatorEngine.swift
//  Just
//
//  Created by Noah Scott on 7/11/19.
//

import Foundation
import Just
import SwiftyJSON

extension SwiftyTranslation.TranslatorEngine {
    /**
     Translate text to another language. Use the ISO-639-1 Code: https://cloud.google.com/translate/docs/languages
     */
    /// - parameter outputLanguage: The language to translate your text to
    /// - parameter text: The text to translate
    public func translate(outputLanguage: String, text: String) throws -> [String : String] {
        var translation : [String : String] = [:]
        let url = SwiftyTranslation.API.translate.rawValue.replacingOccurrences(of: "{{TEXT}}", with: text).replacingOccurrences(of: "{{TARGET}}", with: outputLanguage).replacingOccurrences(of: "{{KEY}}", with: self.apiKey!)
        let httpRequest = Just.get(url)
        if httpRequest.text == nil {
            throw SwiftyTranslation.translationError.responseTextNil
        } else {
            let jsonData = JSON(httpRequest.content!)
            translation = ["detectedLanguage" : jsonData["data"].dictionaryValue["translations"]![0].dictionaryValue["detectedSourceLanguage"]!.stringValue, "translation": jsonData["data"].dictionaryValue["translations"]![0].dictionaryValue["translatedText"]!.stringValue]
        }
        return translation
    }
}
