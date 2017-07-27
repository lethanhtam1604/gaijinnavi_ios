//
//  LanguageManager.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/3/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

class LanguageManager {

    private static var sharedInstance: LanguageManager!
    
    var languages = [Language]()
    
    static func getInstance() -> LanguageManager {
        if(sharedInstance == nil) {
            sharedInstance = LanguageManager()
        }
        return sharedInstance
    }
    
    private init() {
        
        var language = Language()
        language.id = 0
        language.language = "Default"
        language.code = ""
        languages.append(language)
        
        language = Language()
        language.id = 1
        language.language = "日本語 (Japanese)"
        language.code = "ja"
        languages.append(language)
        
        language = Language()
        language.id = 2
        language.language = "English (English)"
        language.code = "en"
        languages.append(language)
        
        language = Language()
        language.id = 3
        language.language = "Tiếng việt (Vietnamese)"
        language.code = "vi"
        languages.append(language)
    }
}
