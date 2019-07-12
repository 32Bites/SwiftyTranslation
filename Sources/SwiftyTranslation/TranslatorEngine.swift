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
     Translate text to another language. Use the ISO-639-1 Code: https://https://cloud.google.com/translate/docs/languages
     */
    public func translate(outputLanguage: String, text: String) throws -> String {
        var translation : String = ""
        let url = SwiftyTranslation.API.translate.rawValue.replacingOccurrences(of: "{{TEXT}}", with: text).replacingOccurrences(of: "{{TARGET}}", with: outputLanguage)
        let httpRequest = Just.get(url)
        if httpRequest.text == nil {
            throw SwiftyTranslation.translationError.responseTextNil
        } else {
            let jsonData = JSON(httpRequest.text!).dictionary!
            print(jsonData)
        }
        return translation
    }
}
