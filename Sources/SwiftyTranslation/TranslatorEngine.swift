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
     - parameter inputText: The text to translate.
     */
    public func translate(outputLanguage: String, inputText: String) throws -> [String : String] {
        guard let text = inputText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("URL encoding has failed.")
            return ["errorType" : "URLEncodingFailed"]
        }
        let url = SwiftyTranslation.API.translate.rawValue.replacingOccurrences(of: "{{TEXT}}", with: text).replacingOccurrences(of: "{{TARGET}}", with: outputLanguage).replacingOccurrences(of: "{{KEY}}", with: self.apiKey)
        let httpRequest = Just.get(url)
        guard let content = httpRequest.content else {
            print("API Response is nil.")
            throw SwiftyTranslation.networkError.responseNil
        }
        let jsonData = JSON(content)
        guard let translations = jsonData["data"].dictionaryValue["translations"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        guard let detectedLanguage = translations[0].dictionaryValue["detectedSourceLanguage"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        guard let translatedText = translations[0].dictionaryValue["translatedText"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        return ["detectedLanguage" : detectedLanguage.stringValue, "translatedText": translatedText.stringValue]
    }
    
    
    /**
     Detect the language of a string. Outputs an ISO-639-1 Code. See: https://cloud.google.com/translate/docs/languages
     
     - parameter inputText: The text to detect the language for.
     */
    public func detect(inputText: String) throws -> [String : Any] {
        let text = inputText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = SwiftyTranslation.API.detect.rawValue.replacingOccurrences(of: "{{TEXT}}", with: text).replacingOccurrences(of: "{{KEY}}", with: self.apiKey)
        let httpRequest = Just.get(url)
        guard let content = httpRequest.content else {
            print("API Response is nil.")
            throw SwiftyTranslation.networkError.responseNil
        }
        let jsonData = JSON(content)
        guard let detections = jsonData["data"].dictionaryValue["detections"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        guard let detectedLanguage = detections.arrayValue[0].arrayValue[0].dictionaryValue["language"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        guard let isReliable = detections.arrayValue[0].arrayValue[0].dictionaryValue["isReliable"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        guard let confidence = detections.arrayValue[0].arrayValue[0].dictionaryValue["confidence"] else {
            print("An error has occured. Here is the API response: \(jsonData)")
            throw SwiftyTranslation.networkError.unknownError
        }
        return ["detectedLanguage" : detectedLanguage.stringValue, "isReliable" : isReliable.boolValue, "confidence" : confidence.doubleValue]
    }
}
