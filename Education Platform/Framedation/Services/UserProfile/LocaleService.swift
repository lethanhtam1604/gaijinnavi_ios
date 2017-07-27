//
//  LocaleService.swift
//  Education Platform
//
//  Created by NguyenHung on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

//public struct Country {
//    //Name of the country
//    public let name : String
//    //country code of the country
//    public let code : String
//}

class LocaleService: NSObject {
    static let sharedInstance = LocaleService();
    
    var countryData = [CountryModel]()
    
    private  override init() {
        
    }
    
    func loadData() -> [CountryModel] {
        guard let path = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") else {
            print("could not find CountryCodes.json")
            return []
        } 
        
        do {
            let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            
            var currentCountryCode: String?
            
            if let local = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
                currentCountryCode = local
            }
            
            guard let countries = json as? NSArray else {
                print("countries is not an array")
                return []
            }
            
            for subJson in countries{
                
                guard let subJson = subJson as? [String: String], let countryName = subJson["name"], let countryCode = subJson["code"] else {
                    
                    print("couldn't parse json")
                    
                    break
                }
                
                let country = CountryModel(name: countryName, code: countryCode)
                
                // set current country if it's the local country
                //if country.code == countryCode {
                   //do something
                //}
                // append country
                countryData.append(country)
            }
            countryData.sort { $1.name > $0.name }
  
        } catch {
            print("error reading file")
            
        }
        print("Hung--> countryData \(countryData)")
        return countryData
    }
}
