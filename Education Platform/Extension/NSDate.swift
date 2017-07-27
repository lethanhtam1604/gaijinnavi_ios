//
//  NSDate.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/24/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import JSQMessagesViewController


extension NSDate {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601) as Calendar!
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
    var iso8601: String { return Formatter.iso8601.string(from: self as Date) }
    
    func timeElapsed(_ date: Date, local: String) -> String {
        
        let seconds = Date().timeIntervalSince(date)
        var elapsed: String
        if seconds  < 48 * 60 * 60 {
        if seconds < 60 {
            elapsed = "just_now".localized()
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins".localized() : "min".localized()
            elapsed = "\(minutes) \(suffix) " + "ago".localized()
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours".localized() : "hour".localized()
            elapsed = "\(hours) \(suffix) " + "ago".localized()
        } 
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days".localized() : "day".localized()
            elapsed = "\(days) \(suffix) " + "ago".localized()
        }
        }
        else {
            let formater = DateFormatter()
            switch local
            {
            case "vi":
                formater.dateFormat = "dd MMMM, yyyy"
                formater.locale =  NSLocale(localeIdentifier: "vi_VN") as Locale!
                elapsed = formater.string(from: date)
            break
            case "en":
                formater.dateFormat = "MMMM dd, yyyy"
                formater.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
                elapsed = formater.string(from: date)
            break
            case "ja":
                formater.dateFormat = "yyyy, MMMM dd"
                formater.locale =  NSLocale(localeIdentifier: "ja_JP") as Locale!
                elapsed = formater.string(from: date)
            break
            default:
                formater.dateFormat = "MMMM dd, yyyy"
                elapsed = formater.string(from: date)
                break
            }
        }
        return elapsed
    }
    

}
