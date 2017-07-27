//
//  JobServices.swift
//  Education Platform
//
//  Created by nquan on 2/20/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class JobServices {
    
    static private var sharedInstance: JobServices!
    
    static var headers: HTTPHeaders!
    
    static func setHeader(token: String) {
        headers = ["lang": UserDefaultManager.getInstance().getLanguageCode()!, "X-Auth-Token": token]
    }

    static func getJobs(parameters: [String:Any], completion: @escaping (_ jobs: [JobListResult], _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        Alamofire.request(Global.newBaseURL + "api/jobs", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                var jobs = [JobListResult]()
                let dataJobs = json["data"]["Jobs"].arrayValue
                if (success == true) {
                    for eachjob in dataJobs {
                        
                        let job = JobListResult()
                        
                        //JobData
                        let jobresult = JobResult()
                        jobresult.Id = eachjob["JobData"]["MainInfo"]["Id"].int64Value
                        jobresult.Major = eachjob["JobData"]["MainInfo"]["Major"].intValue
                        jobresult.MinimumSalary = eachjob["JobData"]["MainInfo"]["MinimumSalary"].stringValue
                        jobresult.JobRequest = eachjob["JobData"]["MainInfo"]["JobRequest"].stringValue
                        jobresult.Language = eachjob["JobData"]["MainInfo"]["Language"].stringValue
                        jobresult.ContractTime = eachjob["JobData"]["MainInfo"]["ContractTime"].stringValue
                        jobresult.TimeWork = eachjob["JobData"]["MainInfo"]["TimeWork"].stringValue
                        jobresult.CompanyId = eachjob["JobData"]["MainInfo"]["CompanyId"].int64Value
                        jobresult.PostId = eachjob["JobData"]["MainInfo"]["PostId"].int64Value
                        jobresult.JobType = eachjob["JobData"]["MainInfo"]["JobType"].intValue
                        jobresult.updated_time = eachjob["JobData"]["MainInfo"]["updated_time"].stringValue
                        jobresult.updated_uid = eachjob["JobData"]["MainInfo"]["updated_uid"].int64Value
                        jobresult.Image = eachjob["JobData"]["MainInfo"]["Image"].stringValue
                        jobresult.DeadLine = eachjob["JobData"]["MainInfo"]["DeadLine"].stringValue
                        jobresult.Title = eachjob["JobData"]["MainInfo"]["Title"].stringValue
                        
                        jobresult.JobCode = eachjob["JobData"]["ExtraInfo"]["JobCode"].stringValue
                        jobresult.Documents = eachjob["JobData"]["ExtraInfo"]["Documents"].stringValue
                        jobresult.StartTime = eachjob["JobData"]["ExtraInfo"]["StartTime"].stringValue

                        job.JobData = jobresult
                        
                        let postdata = SchoolPost()
                        postdata.Id = eachjob["PostData"]["Id"].intValue
                        postdata.Title = eachjob["PostData"]["Title"].stringValue
                        postdata.Description = eachjob["PostData"]["Description"].stringValue
                        postdata.DescriptionHtml = eachjob["PostData"]["DescriptionHtml"].stringValue
                        postdata.ShortDescription = eachjob["PostData"]["ShortDescription"].stringValue
                        postdata.PostType = eachjob["PostData"]["PostType"].intValue
                        postdata.Status = eachjob["PostData"]["Status"].intValue
                        postdata.Highlight = eachjob["PostData"]["Highlight"].boolValue
                        job.PostData = postdata
                        
                        let companyResult = CompanyResult()
                        companyResult.Id = eachjob["CompanyData"]["CompanyData"]["Id"].int64Value
                        companyResult.Description = eachjob["CompanyData"]["CompanyData"]["Description"].stringValue
                        companyResult.DescriptionHtml = eachjob["CompanyData"]["CompanyData"]["DescriptionHtml"].stringValue
                        companyResult.Name = eachjob["CompanyData"]["CompanyData"]["Name"].stringValue
                        companyResult.Size = eachjob["CompanyData"]["CompanyData"]["Size"].intValue
                        companyResult.UniformRule = eachjob["CompanyData"]["CompanyData"]["UniformRule"].stringValue
                        companyResult.BussinessNo = eachjob["CompanyData"]["CompanyData"]["BussinessNo"].intValue
                        companyResult.updated_time = eachjob["CompanyData"]["CompanyData"]["updated_time"].stringValue
                        companyResult.Image = eachjob["CompanyData"]["CompanyData"]["Image"].stringValue
                        companyResult.BannerImage = eachjob["CompanyData"]["CompanyData"]["BannerImage"].stringValue
                        job.CompanyData = companyResult
                        
                        
                        let benefitdatas = eachjob["CompanyData"]["BenefitsData"].arrayValue
                        for each in benefitdatas{
                            let temp =  BenefitsResult()
                            temp.Id =  each["Id"].int64Value
                            temp.Name = each["Name"].stringValue
                            temp.Description = each["Description"].stringValue
                            job.BenefitsData.append(temp)
                        }
                        
                        let location = Location()
                        location.Id = eachjob["CompanyData"]["LocationData"]["Id"].intValue
                        location.Title = eachjob["CompanyData"]["LocationData"]["Title"].stringValue
                        location.FullAddress = eachjob["CompanyData"]["LocationData"]["FullAddress"].stringValue
                        location.PostId = eachjob["CompanyData"]["LocationData"]["PostId"].intValue
                        location.PostalCode = eachjob["CompanyData"]["LocationData"]["PostalCode"].intValue
                        location.CountryCode = eachjob["CompanyData"]["LocationData"]["CountryCode"].intValue
                        location.Latitude = eachjob["CompanyData"]["LocationData"]["Latitude"].doubleValue
                        location.Longtitude = eachjob["CompanyData"]["LocationData"]["Longtitude"].doubleValue
                        job.LocationData = location
                        
                        let author = AuthorResult()
                        author.Id =  eachjob["AuthorData"]["Id"].intValue
                        author.UserName =  eachjob["AuthorData"]["UserName"].stringValue
                        author.DisplayName =  eachjob["AuthorData"]["DisplayName"].stringValue
                        author.Biography =  eachjob["AuthorData"]["Biography"].stringValue
                        author.Avatar =  eachjob["AuthorData"]["Avatar"].stringValue
                        job.AuthorData =  author
                        
                        let contactData = ContactData()
                        contactData.Id =  eachjob["ContactData"]["Id"].intValue
                        contactData.Name =  eachjob["ContactData"]["UserName"].stringValue
                        contactData.PhoneNumber =  eachjob["ContactData"]["PhoneNumber"].stringValue
                        contactData.Email =  eachjob["ContactData"]["Email"].stringValue
                        contactData.Website =  eachjob["ContactData"]["Website"].stringValue
                        job.contactData =  contactData
                        
                        let photos = eachjob["CompanyData"]["PhotoData"].arrayValue
                        for each in photos {
                            let temp = Photo()
                            temp.Id = each["Id"].intValue
                            temp.Title = each["Title"].stringValue
                            temp.Description = each["Description"].stringValue
                            temp.Url = each["Url"].stringValue
                            temp.PostId = each["PostId"].intValue
                            job.PhotoData.append(temp)
                        }
                        
                        let tagDatas = eachjob["TagData"].arrayValue
                        for each in tagDatas {
                            let tagData = TagData()
                            tagData.Id = each["Id"].intValue
                            tagData.Name = each["Name"].stringValue
                            tagData.Description = each["Description"].stringValue
                            job.tagDatas.append(tagData)
                        }
                        
                        let typeJob = JobTypeResult()
                        typeJob.Id = eachjob["JobType"]["Id"].intValue
                        typeJob.Name = eachjob["JobType"]["Name"].stringValue
                        typeJob.Description = eachjob["JobType"]["Description"].stringValue
                        job.JobType = typeJob
                        
                        jobs.append(job)
                    }
                    
                    completion(jobs, true, "")
                }
                else {
                    completion(jobs, false, "could_not_connect_to_server_please_try_again".localized())
                }
                break
            case .failure(_):
                completion([JobListResult](), false, "could_not_connect_to_server_please_try_again".localized())
                break
            }
        }
    }
    
    static func getHightlightedJobs(completion: @escaping (_ jobs: [JobListResult], _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        Alamofire.request(Global.newBaseURL + "api/jobs", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                var jobs = [JobListResult]()
                let dataJobs = json["data"]["Jobs"].arrayValue
                if (success == true) {
                    for eachjob in dataJobs {
                        
                        if eachjob["PostData"]["Highlight"].boolValue == false {
                            continue
                        }
                        
                        let job = JobListResult()
                        
                        //JobData
                        let jobresult = JobResult()
                        jobresult.Id = eachjob["JobData"]["MainInfo"]["Id"].int64Value
                        jobresult.Major = eachjob["JobData"]["MainInfo"]["Major"].intValue
                        jobresult.MinimumSalary = eachjob["JobData"]["MainInfo"]["MinimumSalary"].stringValue
                        jobresult.JobRequest = eachjob["JobData"]["MainInfo"]["JobRequest"].stringValue
                        jobresult.Language = eachjob["JobData"]["MainInfo"]["Language"].stringValue
                        jobresult.ContractTime = eachjob["JobData"]["MainInfo"]["ContractTime"].stringValue
                        jobresult.TimeWork = eachjob["JobData"]["MainInfo"]["TimeWork"].stringValue
                        jobresult.CompanyId = eachjob["JobData"]["MainInfo"]["CompanyId"].int64Value
                        jobresult.PostId = eachjob["JobData"]["MainInfo"]["PostId"].int64Value
                        jobresult.JobType = eachjob["JobData"]["MainInfo"]["JobType"].intValue
                        jobresult.updated_time = eachjob["JobData"]["MainInfo"]["updated_time"].stringValue
                        jobresult.updated_uid = eachjob["JobData"]["MainInfo"]["updated_uid"].int64Value
                        jobresult.Image = eachjob["JobData"]["MainInfo"]["Image"].stringValue
                        jobresult.DeadLine = eachjob["JobData"]["MainInfo"]["DeadLine"].stringValue
                        jobresult.Title = eachjob["JobData"]["MainInfo"]["Title"].stringValue
                        
                        jobresult.JobCode = eachjob["JobData"]["ExtraInfo"]["JobCode"].stringValue
                        jobresult.Documents = eachjob["JobData"]["ExtraInfo"]["Documents"].stringValue
                        jobresult.StartTime = eachjob["JobData"]["ExtraInfo"]["StartTime"].stringValue
                        
                        job.JobData = jobresult
                        
                        let postdata = SchoolPost()
                        postdata.Id = eachjob["PostData"]["Id"].intValue
                        postdata.Title = eachjob["PostData"]["Title"].stringValue
                        postdata.Description = eachjob["PostData"]["Description"].stringValue
                        postdata.DescriptionHtml = eachjob["PostData"]["DescriptionHtml"].stringValue
                        postdata.ShortDescription = eachjob["PostData"]["ShortDescription"].stringValue
                        postdata.PostType = eachjob["PostData"]["PostType"].intValue
                        postdata.Status = eachjob["PostData"]["Status"].intValue
                        postdata.Highlight = eachjob["PostData"]["Highlight"].boolValue
                        job.PostData = postdata
                        
                        let companyResult = CompanyResult()
                        companyResult.Id = eachjob["CompanyData"]["CompanyData"]["Id"].int64Value
                        companyResult.Description = eachjob["CompanyData"]["CompanyData"]["Description"].stringValue
                        companyResult.DescriptionHtml = eachjob["CompanyData"]["CompanyData"]["DescriptionHtml"].stringValue
                        companyResult.Name = eachjob["CompanyData"]["CompanyData"]["Name"].stringValue
                        companyResult.Size = eachjob["CompanyData"]["CompanyData"]["Size"].intValue
                        companyResult.UniformRule = eachjob["CompanyData"]["CompanyData"]["UniformRule"].stringValue
                        companyResult.BussinessNo = eachjob["CompanyData"]["CompanyData"]["BussinessNo"].intValue
                        companyResult.updated_time = eachjob["CompanyData"]["CompanyData"]["updated_time"].stringValue
                        companyResult.Image = eachjob["CompanyData"]["CompanyData"]["Image"].stringValue
                        companyResult.BannerImage = eachjob["CompanyData"]["CompanyData"]["BannerImage"].stringValue
                        job.CompanyData = companyResult
                        
                        
                        let benefitdatas = eachjob["CompanyData"]["BenefitsData"].arrayValue
                        for each in benefitdatas{
                            let temp =  BenefitsResult()
                            temp.Id =  each["Id"].int64Value
                            temp.Name = each["Name"].stringValue
                            temp.Description = each["Description"].stringValue
                            job.BenefitsData.append(temp)
                        }
                        
                        let location = Location()
                        location.Id = eachjob["CompanyData"]["LocationData"]["Id"].intValue
                        location.Title = eachjob["CompanyData"]["LocationData"]["Title"].stringValue
                        location.FullAddress = eachjob["CompanyData"]["LocationData"]["FullAddress"].stringValue
                        location.PostId = eachjob["CompanyData"]["LocationData"]["PostId"].intValue
                        location.PostalCode = eachjob["CompanyData"]["LocationData"]["PostalCode"].intValue
                        location.CountryCode = eachjob["CompanyData"]["LocationData"]["CountryCode"].intValue
                        location.Latitude = eachjob["CompanyData"]["LocationData"]["Latitude"].doubleValue
                        location.Longtitude = eachjob["CompanyData"]["LocationData"]["Longtitude"].doubleValue
                        job.LocationData = location
                        
                        let author = AuthorResult()
                        author.Id =  eachjob["AuthorData"]["Id"].intValue
                        author.UserName =  eachjob["AuthorData"]["UserName"].stringValue
                        author.DisplayName =  eachjob["AuthorData"]["DisplayName"].stringValue
                        author.Biography =  eachjob["AuthorData"]["Biography"].stringValue
                        author.Avatar =  eachjob["AuthorData"]["Avatar"].stringValue
                        job.AuthorData =  author
                        
                        let contactData = ContactData()
                        contactData.Id =  eachjob["ContactData"]["Id"].intValue
                        contactData.Name =  eachjob["ContactData"]["UserName"].stringValue
                        contactData.PhoneNumber =  eachjob["ContactData"]["PhoneNumber"].stringValue
                        contactData.Email =  eachjob["ContactData"]["Email"].stringValue
                        contactData.Website =  eachjob["ContactData"]["Website"].stringValue
                        job.contactData =  contactData
                        
                        let photos = eachjob["CompanyData"]["PhotoData"].arrayValue
                        for each in photos {
                            let temp = Photo()
                            temp.Id = each["Id"].intValue
                            temp.Title = each["Title"].stringValue
                            temp.Description = each["Description"].stringValue
                            temp.Url = each["Url"].stringValue
                            temp.PostId = each["PostId"].intValue
                            job.PhotoData.append(temp)
                        }
                        
                        let tagDatas = eachjob["TagData"].arrayValue
                        for each in tagDatas {
                            let tagData = TagData()
                            tagData.Id = each["Id"].intValue
                            tagData.Name = each["Name"].stringValue
                            tagData.Description = each["Description"].stringValue
                            job.tagDatas.append(tagData)
                        }
                        
                        let typeJob = JobTypeResult()
                        typeJob.Id = eachjob["JobType"]["Id"].intValue
                        typeJob.Name = eachjob["JobType"]["Name"].stringValue
                        typeJob.Description = eachjob["JobType"]["Description"].stringValue
                        job.JobType = typeJob
                        
                        jobs.append(job)
                    }
                    
                    completion(jobs, true, "")
                }
                else {
                    completion(jobs, false, "could_not_connect_to_server_please_try_again".localized())
                }
                break
            case .failure(_):
                completion([JobListResult](), false, "could_not_connect_to_server_please_try_again".localized())
                break
            }
        }
    }
    
    static func getListCategoryJob(completion: @escaping (_ result: [JobTypeResult], _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        Alamofire.request(Global.newBaseURL + "api/stuff/liststuff", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                var jobTypes = [JobTypeResult]()
                let dataJobs = json["data"]["JobTypes"].arrayValue
                if (success == true) {
                    for eachjob in dataJobs {
                        
                        if eachjob["LangCode"].stringValue == UserDefaultManager.getInstance().getLanguageCode() {
                            let typeJob = JobTypeResult()
                            typeJob.Id = eachjob["Id"].intValue
                            typeJob.Name = eachjob["Name"].stringValue
                            typeJob.Description = eachjob["Description"].stringValue
                            typeJob.Icon = eachjob["Icon"].stringValue
                            jobTypes.append(typeJob)
                        }
                    }
                    completion(jobTypes, true, "")
                }
                else {
                    completion(jobTypes, false, "could_not_connect_to_server_please_try_again".localized())
                }
                break
            case .failure(_):
                completion([JobTypeResult](), false, "could_not_connect_to_server_please_try_again".localized())
                break
            }
        }
    }
    
    static func getMajorById(majorId: Int, completion: @escaping (_ result: Major?, _ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        Alamofire.request(Global.newBaseURL + "api/stuff/liststuff", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                
                let success = json["success"].boolValue
                if (success == true) {
                    let dataJobs = json["data"]["Majors"].arrayValue
                    var major: Major?

                    for eachjob in dataJobs {
                        if eachjob["Id"].intValue == majorId {
                            major = Major()
                            major?.Id = eachjob["Id"].intValue
                            major?.Name = eachjob["Name"].stringValue
                            break
                        }
                    }
                    completion(major, true, "")
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
