//
//  SearchService.swift
//  Education Platform
//
//  Created by Duy Cao on 12/15/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchKeys{
    //MARK: Instance
    static let sharedInstance = SearchKeys()
    
    
    //MARK: private init
    private init (){
        
    }
    
    //Response Field
    let SCHOOLDATA = "SchoolData"
    let SCHOOLPOST = "PostData"
    let LOCATION = "LocationData"
    let PHOTO = "PhotoData"
    
    //Request Field
    let SCHOOLNAME = "name"
    let MAJOR = "majors"
    let RANKING = "rank"
    let MINFEE = "priceFrom"
    let MAXFEE = "priceTo"
    let CURRENT_PAGE = "currentPage"
    let SERVICE = "services"
    
    
}


class SearchService {
    var holdingRequest : DataRequest!
    var isCancelled : Bool = false
    static let sharedInstrance = SearchService()
    let apiSearchSchool = "api/school/listschool"
    let searchField = SearchKeys.sharedInstance
    var searchParams : [String : Any]
    
    var headers: HTTPHeaders!
    
    func setHeader(token: String) {
        
        if UserDefaultManager.getInstance().getCurrentLanguage() == 0 {
            headers = ["lang": "en", "X-Auth-Token": token]
        }
        else if UserDefaultManager.getInstance().getCurrentLanguage() == 1 {
            headers = ["lang": "jp", "X-Auth-Token": token]
        }
        else if UserDefaultManager.getInstance().getCurrentLanguage() == 2 {
            headers = ["lang": "en", "X-Auth-Token": token]
        }
        else {
            headers = ["lang": "vn", "X-Auth-Token": token]
        }
    }
    
    
    private init() {
        self.searchParams = [String : Any]()
    }
    //MARK: properties
    
    //MARK: method
    func searchSchool(apiSearchString : String = "",
                      params : [String : Any],
                      complete: @escaping (([School],_ totalPage : Int)->()),
                      trial_times : Int = 0){
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        //MARK: Alamofire Session Manager with custom timeout
        //        let sessionManager = Alamofire.SessionManager.default
        //        sessionManager.session.configuration.timeoutIntervalForRequest = 15
        var url : URL!
        
        if apiSearchString.isEmpty {
            url = URL(string: Global.newBaseURL +  self.apiSearchSchool)
        }else{
            url = URL(string: Global.newBaseURL +  apiSearchString)
        }
        //url!, method: HTTPMethod.get, parameters: params, encoding: ArrayParamEncoding()
        
        self.holdingRequest = Alamofire.request(url!, method: HTTPMethod.get, parameters: params, encoding: ArrayParamEncoding(), headers: headers).responseJSON { response in
            
            self.holdingRequest = nil
            switch response.result {
            case .success(let val):
                var schools = [School]()
                let jsonObj = JSON(val)
                let success = jsonObj["success"].boolValue
                let totalPage = jsonObj["data"].dictionaryValue["TotalPage"]?.intValue
                if success {
                    let schoolArray = jsonObj["data"].dictionaryValue["Schools"]?.arrayValue
                    for sch in schoolArray! {
//                        let data = SchoolData(json: sch[self.searchField.SCHOOLDATA].rawString())
//                        let post = SchoolPost(json: sch[self.searchField.SCHOOLPOST].rawString())
//                        let location = Location(json: sch[self.searchField.LOCATION].rawString())
                        let school = School()
                        
//                        school.setData(data: data, post: post,LocationData: location, photos: nil)
                        schools.append(school)
                    }
                    
                }
                
                
                if self.isCancelled {
                    return
                }
                complete(schools, totalPage!)
                break
            case .failure(let err):
                print(err.localizedDescription)
                self.holdingRequest = nil
                if self.isCancelled {
                    return
                }
                self.holdingRequest = nil
                if err._code == NSURLErrorTimedOut {
                    
                    if trial_times == 4 {
                        complete([School](), 1)
                        return
                    }
                    self.searchSchool(params: self.searchParams, complete: complete, trial_times: trial_times+1)
                }else{
                    //TODO: other errors
                    complete([School](), 1)
                }
                
                return
            }
        }
    }
    
    func cancel() -> Bool{
        if self.holdingRequest == nil {
            return false
        }
        self.holdingRequest.cancel()
        self.isCancelled = true
        return true
    }
    
}
