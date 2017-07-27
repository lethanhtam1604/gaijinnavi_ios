//
//  CountryCodeService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/14/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

class CountryCodeService {
    
    private static var sharedInstance: CountryCodeService!
    
    var countryData = [CountryCode]()
    
    static func getInstance() -> CountryCodeService {
        if(sharedInstance == nil) {
            sharedInstance = CountryCodeService()
        }
        return sharedInstance
    }
    
    private init() {
        
        loadData()
    }
    
    func loadData() {
        
        guard let path = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") else {
            print("could not find CountryCodes.json")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            
            
            guard let countries = json as? NSArray else {
                print("countries is not an array")
                return
            }
            
            for subJson in countries{
                
                guard let subJson = subJson as? [String: String], let countryName = subJson["name"], let countryCode = subJson["code"] else {
                    
                    print("couldn't parse json")
                    
                    break
                }
                
                let country = CountryCode()
                country.name = countryName
                country.code = countryCode
                countryData.append(country)
            }
            countryData.sort { $1.name > $0.name }
            
        } catch {
            print("error reading file")
        }
    }
}
