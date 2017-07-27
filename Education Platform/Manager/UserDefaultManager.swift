//
//  UserDefaultManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/29/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class UserDefaultManager {

    private static var sharedInstance: UserDefaultManager!
    
    private let defaults = UserDefaults.standard
    
    private let isInitApp = "isInitApp"
    private let currentUser = "currentUser"
    private let currentLanguage = "currentLanguage"
    private let languageCode = "languageCode"
    private let badgeNumber = "badgenumber"
    private let currentAccountType = "currentAccountType"
    private let currentToken = "currentToken"

    static func getInstance() -> UserDefaultManager {
        if(sharedInstance == nil) {
            sharedInstance = UserDefaultManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }

    func setIsInitApp(value: Bool) {
        defaults.set(value, forKey: isInitApp)
        defaults.synchronize()
    }
    
    func getIsInitApp() -> Bool {
        return defaults.bool(forKey: isInitApp)
    }
    
    func setCurrentUser(roleResult: RoleResult?) {
        var encodedData: Data!
        if roleResult != nil {
            encodedData = NSKeyedArchiver.archivedData(withRootObject: roleResult!)
        }
        defaults.set(encodedData, forKey: currentUser)
        defaults.synchronize()
    }
    
    func getCurrentUser() -> RoleResult? {
        let decoded  = defaults.object(forKey: currentUser) as? Data
        if decoded == nil {
            return nil
        }
        let roleResult = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? RoleResult
        return roleResult
    }
    
    func setCurrentLanguage(value: Int) {
        defaults.set(value, forKey: currentLanguage)
        defaults.synchronize()
    }
    
    func getCurrentLanguage() -> Int? {
        return defaults.integer(forKey: currentLanguage)
    }
    
    func setLanguageCode(value: String) {
        defaults.set(value, forKey: languageCode)
        defaults.synchronize()
    }
    
    func getLanguageCode() -> String? {
        return defaults.string(forKey: languageCode)
    }
    
    func setCurrentBadgeNumber(value: Int) {
        defaults.set(value, forKey: badgeNumber)
        defaults.synchronize()
    }
    
    func getCurrentBadgeNumber() -> Int? {
        return defaults.integer(forKey: badgeNumber)
    }
    
    func setCurrentAccountType(value: String) {
        defaults.set(value, forKey: currentAccountType)
        defaults.synchronize()
    }
    
    func getCurrentAccountType() -> String? {
        return defaults.string(forKey: currentAccountType)
    }
    
    func setCurrentToken(value: String) {
        defaults.set(value, forKey: currentToken)
        defaults.synchronize()
    }
    
    func getCurrentToken() -> String? {
        return defaults.string(forKey: currentToken)
    }
}
