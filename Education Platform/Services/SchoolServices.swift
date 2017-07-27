//
//  SchoolServices.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 6/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SchoolServices {
    
    static private var sharedInstance: SchoolServices!
    
    static var headers: HTTPHeaders!
    
    static func setHeader(token: String) {
        headers = ["lang": UserDefaultManager.getInstance().getLanguageCode()!, "X-Auth-Token": token]
    }
    
    static func getAreas(amount: Int, completion: @escaping (_ schoolAreas: [SchoolArea], _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        Alamofire.request(Global.newBaseURL + "api/school/areas/highlight?amount=" + String(amount), method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                var schoolAreas = [SchoolArea]()
                
                let dataArea = json["data"].arrayValue
                
                if (success == true) {
                    
                    for eachData in dataArea {
                        
                        let schoolArea = SchoolArea()
                        schoolArea.type = eachData["Type"].intValue
                        
                        let dataSchool = eachData["Schools"].arrayValue
                        var isSetArea = false
                        
                        for eachSchool in dataSchool {
                            
                            let school = School()
                            
                            let schoolData = SchoolData()
                            schoolData.Id = eachSchool["SchoolData"]["Id"].intValue
                            schoolData.PostId = eachSchool["SchoolData"]["PostId"].intValue
                            schoolData.Image = eachSchool["SchoolData"]["Image"].stringValue
                            schoolData.ImageLocation = eachSchool["SchoolData"]["ImageLocation"].stringValue
                            schoolData.Ranking = eachSchool["SchoolData"]["Ranking"].intValue
                            schoolData.Life = eachSchool["SchoolData"]["Life"].stringValue
                            schoolData.TypeId = eachSchool["SchoolData"]["TypeId"].intValue
                            schoolData.AvgFees = eachSchool["SchoolData"]["AvgFees"].intValue
                            schoolData.SchoolId = eachSchool["SchoolData"]["SchoolId"].intValue
                            school.schoolData = schoolData
                            
                            let schoolPost = SchoolPost()
                            schoolPost.Id = eachSchool["PostData"]["Id"].intValue
                            schoolPost.Title = eachSchool["PostData"]["Title"].stringValue
                            schoolPost.Description = eachSchool["PostData"]["Description"].stringValue
                            schoolPost.DescriptionHtml = eachSchool["PostData"]["DescriptionHtml"].stringValue
                            schoolPost.ShortDescription = eachSchool["PostData"]["ShortDescription"].stringValue
                            schoolPost.PostType = eachSchool["PostData"]["PostType"].intValue
                            schoolPost.Status = eachSchool["PostData"]["Status"].intValue
                            schoolPost.Highlight = eachSchool["PostData"]["Highlight"].boolValue
                            schoolPost.NewsId = eachSchool["PostData"]["NewsId"].intValue
                            school.schoolPost = schoolPost
                            
                            let areaData = eachSchool["AreaData"].arrayValue
                            
                            for eachArea in areaData {
                                
                                let areaData = AreaData()
                                areaData.Id = eachArea["Id"].intValue
                                areaData.NameEn = eachArea["NameEn"].stringValue
                                areaData.NameJp = eachArea["NameJp"].stringValue
                                areaData.GroupAreaId = eachArea["GroupAreaId"].intValue
                                areaData.HighLight = eachArea["HighLight"].boolValue
                                
                                school.areaDatas.append(areaData)
                                
                                if !isSetArea {
                                    isSetArea = true
                                    schoolArea.areaData = areaData
                                }
                            }
                            
                            schoolArea.school.append(school)
                        }
                        
                        schoolAreas.append(schoolArea)
                    }
                    
                    completion(schoolAreas, true, "")
                }
                else {
                    completion(schoolAreas, false, "could_not_connect_to_server_please_try_again".localized())
                }
                break
            case .failure(_):
                completion([SchoolArea](), false, "could_not_connect_to_server_please_try_again".localized())
                break
            }
        }
    }
    
    static func getSchoolsByAre(pageSize: Int, currentPage: Int, groupArea: Int, area: Int, completion: @escaping (_ schools: [School], _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        Alamofire.request(Global.newBaseURL + "api/school/listschool?pageSize=" + String(pageSize) + "&currentPage=" + String(currentPage) + "&langCode=" + UserDefaultManager.getInstance().getLanguageCode()! + "&priceFrom=0&priceTo=100000&groupArea=" + String(groupArea) + "&area=" + String(area), method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                
                if (success == true) {
                    
                    let dataSchool = json["data"]["Schools"].arrayValue
                    var schools = [School]()
                    
                    for eachSchool in dataSchool {
                        
                        let school = School()
                        
                        let schoolData = SchoolData()
                        schoolData.Id = eachSchool["SchoolData"]["Id"].intValue
                        schoolData.PostId = eachSchool["SchoolData"]["PostId"].intValue
                        schoolData.Image = eachSchool["SchoolData"]["Image"].stringValue
                        schoolData.ImageLocation = eachSchool["SchoolData"]["ImageLocation"].stringValue
                        schoolData.Ranking = eachSchool["SchoolData"]["Ranking"].intValue
                        schoolData.Life = eachSchool["SchoolData"]["Life"].stringValue
                        schoolData.TypeId = eachSchool["SchoolData"]["TypeId"].intValue
                        schoolData.AvgFees = eachSchool["SchoolData"]["AvgFees"].intValue
                        schoolData.SchoolId = eachSchool["SchoolData"]["SchoolId"].intValue
                        school.schoolData = schoolData
                        
                        let schoolPost = SchoolPost()
                        schoolPost.Id = eachSchool["PostData"]["Id"].intValue
                        schoolPost.Title = eachSchool["PostData"]["Title"].stringValue
                        schoolPost.Description = eachSchool["PostData"]["Description"].stringValue
                        schoolPost.DescriptionHtml = eachSchool["PostData"]["DescriptionHtml"].stringValue
                        schoolPost.ShortDescription = eachSchool["PostData"]["ShortDescription"].stringValue
                        schoolPost.PostType = eachSchool["PostData"]["PostType"].intValue
                        schoolPost.Status = eachSchool["PostData"]["Status"].intValue
                        schoolPost.Highlight = eachSchool["PostData"]["Highlight"].boolValue
                        schoolPost.NewsId = eachSchool["PostData"]["NewsId"].intValue
                        school.schoolPost = schoolPost
                        
                        let areaData = eachSchool["AreaData"].arrayValue
                        
                        for eachArea in areaData {
                            
                            let areaData = AreaData()
                            areaData.Id = eachArea["Id"].intValue
                            areaData.NameEn = eachArea["NameEn"].stringValue
                            areaData.NameJp = eachArea["NameJp"].stringValue
                            areaData.GroupAreaId = eachArea["GroupAreaId"].intValue
                            areaData.HighLight = eachArea["HighLight"].boolValue
                            
                            school.areaDatas.append(areaData)
                            
                        }
                        
                        schools.append(school)
                    }
                    
                    completion(schools, true, "")
                }
                else {
                    completion([School](), false, "could_not_connect_to_server_please_try_again".localized())
                }
                break
            case .failure(_):
                completion([School](), false, "could_not_connect_to_server_please_try_again".localized())
                break
            }
        }
    }
    
    static func getSchoolById(schoolId: Int, completion: @escaping (_ school: School?, _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        Alamofire.request(Global.newBaseURL + "api/school/" + String(schoolId), method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                
                if (success == true) {
                    
                    let school = School()
                    
                    let schoolData = SchoolData()
                    schoolData.Id = json["data"]["SchoolData"]["Id"].intValue
                    schoolData.PostId = json["data"]["SchoolData"]["PostId"].intValue
                    schoolData.Image = json["data"]["SchoolData"]["Image"].stringValue
                    schoolData.ImageLocation = json["data"]["SchoolData"]["ImageLocation"].stringValue
                    schoolData.Ranking = json["data"]["SchoolData"]["Ranking"].intValue
                    schoolData.Life = json["data"]["SchoolData"]["Life"].stringValue
                    schoolData.TypeId = json["data"]["SchoolData"]["TypeId"].intValue
                    schoolData.AvgFees = json["data"]["SchoolData"]["AvgFees"].intValue
                    schoolData.SchoolId = json["data"]["SchoolData"]["SchoolId"].intValue
                    school.schoolData = schoolData
                    
                    let schoolPost = SchoolPost()
                    schoolPost.Id = json["data"]["PostData"]["Id"].intValue
                    schoolPost.Title = json["data"]["PostData"]["Title"].stringValue
                    schoolPost.Description = json["data"]["PostData"]["Description"].stringValue
                    schoolPost.DescriptionHtml = json["data"]["PostData"]["DescriptionHtml"].stringValue
                    schoolPost.ShortDescription = json["data"]["PostData"]["ShortDescription"].stringValue
                    schoolPost.PostType = json["data"]["PostData"]["PostType"].intValue
                    schoolPost.Status = json["data"]["PostData"]["Status"].intValue
                    schoolPost.Highlight = json["data"]["PostData"]["Highlight"].boolValue
                    schoolPost.NewsId = json["data"]["PostData"]["NewsId"].intValue
                    school.schoolPost = schoolPost
                    
                    let contact = Contact()
                    contact.Id = json["data"]["ContactData"]["Id"].intValue
                    contact.PostId = json["data"]["ContactData"]["PostId"].intValue
                    contact.Name = json["data"]["ContactData"]["Name"].stringValue
                    contact.PhoneNumber = json["data"]["ContactData"]["PhoneNumber"].stringValue
                    contact.Email = json["data"]["ContactData"]["Email"].stringValue
                    contact.Website = json["data"]["ContactData"]["Website"].stringValue
                    school.contactData = contact

                    
                    let location = Location()
                    location.Id = json["data"]["LocationData"]["Id"].intValue
                    location.FullAddress = json["data"]["LocationData"]["FullAddress"].stringValue
                    location.PostalCode = json["data"]["LocationData"]["PostalCode"].intValue
                    location.StateCityLocation = json["data"]["LocationData"]["StateCityLocation"].stringValue
                    location.CountryCode = json["data"]["LocationData"]["CountryCode"].intValue
                    location.PostId = json["data"]["LocationData"]["PostId"].intValue
                    location.Latitude = json["data"]["LocationData"]["Latitude"].doubleValue
                    location.Longtitude = json["data"]["LocationData"]["Longtitude"].doubleValue
                    school.locationData = location
                    
                    let areaData = json["data"]["AreaData"].arrayValue
                    
                    for eachArea in areaData {
                        
                        let areaData = AreaData()
                        areaData.Id = eachArea["Id"].intValue
                        areaData.NameEn = eachArea["NameEn"].stringValue
                        areaData.NameJp = eachArea["NameJp"].stringValue
                        areaData.GroupAreaId = eachArea["GroupAreaId"].intValue
                        areaData.HighLight = eachArea["HighLight"].boolValue
                        
                        school.areaDatas.append(areaData)
                    }

                    let serviceData = json["data"]["ServiceData"].arrayValue
                    
                    for eachService in serviceData {
                        
                        let service = Service()
                        service.Id = eachService["Id"].intValue
                        service.Name = eachService["Name"].stringValue
                        service.Description = eachService["Description"].stringValue
                        school.services.append(service)
                    }
                    
                    completion(school, true, "")
                }
                else {
                    completion(nil, false, "could_not_connect_to_server_please_try_again".localized())
                }
                break
            case .failure(_):
                completion(nil, false, "could_not_connect_to_server_please_try_again".localized())
                break
            }
        }
    }
    
}
