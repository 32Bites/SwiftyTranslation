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
     Translate text to another language. Use an ISO-639-1 Code. See: https://cloud.google.com/translate/docs/languages
     
     - parameter outputLanguage: The language to translate your text to.
     - parameter inputText: The text to translate
     */
    public func translate(outputLanguage: String, inputText: String) throws -> [String : String] {
        var translation : [String : String] = [:]
        let text = inputText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = SwiftyTranslation.API.translate.rawValue.replacingOccurrences(of: "{{TEXT}}", with: text).replacingOccurrences(of: "{{TARGET}}", with: outputLanguage).replacingOccurrences(of: "{{KEY}}", with: self.apiKey!)
        let httpRequest = Just.get(url)
        if httpRequest.content == nil {
            throw SwiftyTranslation.networkError.responseNil
        }
        let jsonData = JSON(httpRequest.content!)
        let detectedLanguage = jsonData["data"].dictionaryValue["translations"]![0].dictionaryValue["detectedSourceLanguage"]!.stringValue
        let translatedText = jsonData["data"].dictionaryValue["translations"]![0].dictionaryValue["translatedText"]!.stringValue
        translation = ["detectedLanguage" : detectedLanguage, "translatedText": translatedText]
        return translation
    }
    
    
    /**
     Detect the language of a string. Outputs an ISO-639-1 Code. See: https://cloud.google.com/translate/docs/languages
     
     - parameter inputText: The text to detected the language for.
     */
    public func detect(inputText: String) throws -> [String : Any] {
        let text = inputText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = SwiftyTranslation.API.detect.rawValue.replacingOccurrences(of: "{{TEXT}}", with: text).replacingOccurrences(of: "{{KEY}}", with: self.apiKey!)
        let httpRequest = Just.get(url)
        if httpRequest.content == nil {
            throw SwiftyTranslation.networkError.responseNil
        }
        let jsonData = JSON(httpRequest.content!)
        let detectedLanguage = jsonData["data"].dictionaryValue["detections"]!.arrayValue[0].arrayValue[0].dictionaryValue["language"]!.stringValue
        let isReliable = jsonData["data"].dictionaryValue["detections"]!.arrayValue[0].arrayValue[0].dictionaryValue["isReliable"]!.boolValue
        let confidence = jsonData["data"].dictionaryValue["detections"]!.arrayValue[0].arrayValue[0].dictionaryValue["confidence"]!.doubleValue
        return ["detectedLanguage" : detectedLanguage, "isReliable" : isReliable, "confidence" : confidence]
    }
}
