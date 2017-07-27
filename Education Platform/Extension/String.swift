//
//  String+Extentions.swift
//  iCareBenefit
//
//  Created by Nam Truong on 6/10/15.
//  Copyright © 2015 Nam Truong. All rights reserved.
//

import UIKit

extension String {

    
    func length() -> Int {
        return self.characters.count
    }
    
    func IntValue() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func contains(st:String) -> Bool {
        return NSString(string: self).contains(st)
    }
    
    func RemoveExcessSpace() -> String {
        let tempArray = self.DoSplitStringRemoveNilObject(separateString: " ")
        var output = ""
        for (index, element) in tempArray.enumerated() {
            output += element
            if index < (tempArray.count - 1) {
                output += " "
            }
        }
        return output
    }
    
    func urlDecode() ->  String {
        return self.removingPercentEncoding!
    }
    
    // Get Array From String with separateString and Remove Nil Object
    
    func DoSplitStringRemoveNilObject (separateString: String) -> [String] {
        let tempArray = NSMutableArray(array: self.components(separatedBy: separateString))
        tempArray.remove("")
        return NSArray(array: tempArray) as! [String]
    }
    
    func DoSplitCharacterOfStringRemoveNilObject (separateString: String) -> [String] {
        let tempArray = NSMutableArray(array: self.components(separatedBy: separateString))
        tempArray.remove("")
        return NSArray(array: tempArray) as! [String]
    }
    
    func toNSDictionary() -> NSDictionary? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.toNSDictionary()
        } else {
            return nil
        }
        
    }
    
    func toArray() -> NSArray? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.toArray()
        } else {
            return nil
        }
    }
    func removeSpaceAndTolowerCaseString()->String{
       return self.replacingOccurrences(of: " ", with: "").localizedLowercase
    }
    
    func toNSString() -> NSString{
        return NSString(string: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^((\\+)|())[0-9]{3,100}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidAccount() -> Bool {
        let RegEx = "\\A\\w{1,18}\\z"
        let accountTest = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return accountTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let RegEx = ".{8,18}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  passwordTest.evaluate(with: self)
        return result
    }
    
    func isValidName() -> Bool {
        let RegEx = ".{1,50}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidAddress() -> Bool {
        let RegEx = ".{1,200}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidDescription() -> Bool {
        let RegEx = ".{1,500}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidNationality() -> Bool {
        let RegEx = ".{1,10}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    var dateFromISO8601: NSDate? {
        return NSDate.Formatter.iso8601.date(from: self) as NSDate?
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func widthWithConstrainedWidth(font: UIFont) -> CGFloat {
        return self.widthWithConstrainedWidth(font: font)
    }

}

