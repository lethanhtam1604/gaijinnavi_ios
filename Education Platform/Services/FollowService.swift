//
//  FollowService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/28/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol FollowServiceDelegate {
    func getFollowingListOwnerFinished(success: Bool, message: String, result: [UserResult])
    func getFollowingListFinished(success: Bool, message: String, result: [UserResult])
    func getFollowedListFinished(success: Bool, message: String, result: [UserResult])
    func followFinised(success: Bool, message: String)
    func unFollowFinised(success: Bool, message: String)
}

class FollowService {
    
    static var headers: HTTPHeaders!
    
    static func setHeader(token: String) {
        
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
    
    static func getFollowingListOwner(followServiceDelegate: FollowServiceDelegate?) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        var result = [UserResult]()
        Alamofire.request(Global.newBaseURL + "api/user/getSubscribes", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    let data = json["data"]["Users"].arrayValue
                    
                    for item in data {
                        let userResult = UserResult()
                        userResult.Id = item["Id"].intValue
                        userResult.DisplayName = item["DisplayName"].stringValue
                        userResult.UserName = item["UserName"].stringValue
                        userResult.Email = item["Email"].stringValue
                        userResult.Password = item["Password"].stringValue
                        userResult.Status = item["Status"].stringValue
                        userResult.RoleId = item["RoleId"].intValue
                        userResult.Avatar = item["Avatar"].stringValue
                        userResult.DOB = item["DOB"].stringValue
                        userResult.Biography = item["Biography"].stringValue
                        userResult.Gender = item["Gender"].intValue
                        userResult.Active = item["Active"].intValue
                        userResult.Phone = item["Phone"].stringValue
                        userResult.Address = item["Address"].stringValue
                        userResult.Token = item["Token"].stringValue
                        result.append(userResult)
                        
                    }
                    
                    if followServiceDelegate != nil {
                        followServiceDelegate?.getFollowingListOwnerFinished(success: true, message: "", result: result)
                    }
                    
                }
                else {
                    if followServiceDelegate != nil {
                        followServiceDelegate?.getFollowingListOwnerFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), result: result)
                    }
                }
            case .failure(_):
                if followServiceDelegate != nil {
                    followServiceDelegate?.getFollowingListOwnerFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), result: result)
                }
                return
            }
        }
    }
    
    static func getFollowingList(userId: Int, followServiceDelegate: FollowServiceDelegate?) {
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        var result = [UserResult]()
        Alamofire.request(Global.newBaseURL + "api/user/getUserISubscribe/" + String(userId), headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                if json["success"].intValue == 1 {
                    let data = json["data"]["Users"].arrayValue
                    
                    for item in data {
                        let userResult = UserResult()
                        userResult.Id = item["Id"].intValue
                        userResult.DisplayName = item["DisplayName"].stringValue
                        userResult.UserName = item["UserName"].stringValue
                        userResult.Email = item["Email"].stringValue
                        userResult.Password = item["Password"].stringValue
                        userResult.Status = item["Status"].stringValue
                        userResult.RoleId = item["RoleId"].intValue
                        userResult.Avatar = item["Avatar"].stringValue
                        userResult.DOB = item["DOB"].stringValue
                        userResult.Biography = item["Biography"].stringValue
                        userResult.Gender = item["Gender"].intValue
                        userResult.Active = item["Active"].intValue
                        userResult.Phone = item["Phone"].stringValue
                        userResult.Address = item["Address"].stringValue
                        userResult.Token = item["Token"].stringValue
                        result.append(userResult)
      
                    }
                    
                    if followServiceDelegate != nil {
                        followServiceDelegate?.getFollowingListFinished(success: true, message: "", result: result)
                    }
                    
                }
                else {
                    if followServiceDelegate != nil {
                        followServiceDelegate?.getFollowingListFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), result: result)
                    }
                }
            case .failure(_):
                if followServiceDelegate != nil {
                    followServiceDelegate?.getFollowingListFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), result: result)
                }
                return
            }
        }
    }
    
    static func getFollowedList(userId: Int, followServiceDelegate: FollowServiceDelegate?) {
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        var result = [UserResult]()
        Alamofire.request(Global.newBaseURL + "api/user/getUsersSubscribeMe/" + String(userId), headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    let data = json["data"]["Users"].arrayValue
                    
                    for item in data {
                        let userResult = UserResult()
                        userResult.Id = item["Id"].intValue
                        userResult.DisplayName = item["DisplayName"].stringValue
                        userResult.UserName = item["UserName"].stringValue
                        userResult.Email = item["Email"].stringValue
                        userResult.Password = item["Password"].stringValue
                        userResult.Status = item["Status"].stringValue
                        userResult.RoleId = item["RoleId"].intValue
                        userResult.Avatar = item["Avatar"].stringValue
                        userResult.DOB = item["DOB"].stringValue
                        userResult.Biography = item["Biography"].stringValue
                        userResult.Gender = item["Gender"].intValue
                        userResult.Active = item["Active"].intValue
                        userResult.Phone = item["Phone"].stringValue
                        userResult.Address = item["Address"].stringValue
                        userResult.Token = item["Token"].stringValue
                        result.append(userResult)
                        
                    }
                    
                    if followServiceDelegate != nil {
                        followServiceDelegate?.getFollowedListFinished(success: true, message: "", result: result)
                    }
                    
                }
                else {
                    if followServiceDelegate != nil {
                        followServiceDelegate?.getFollowedListFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), result: result)
                    }
                }
            case .failure(_):
                if followServiceDelegate != nil {
                    followServiceDelegate?.getFollowedListFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), result: result)
                }
                return
            }
        }
    }
    
    static func follow(userId: Int, followServiceDelegate: FollowServiceDelegate?) {
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        let body = ["id": userId] as [String : Any]
        
        Alamofire.request(Global.newBaseURL + "api/user/subscribe", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    if followServiceDelegate != nil {
                        followServiceDelegate?.followFinised(success: true, message: "")
                    }
                }
                else {
                    followServiceDelegate?.followFinised(success: false, message: "could_not_connect_to_server_please_try_again".localized())
                }
            case .failure(_):
                followServiceDelegate?.followFinised(success: false, message: "could_not_connect_to_server_please_try_again".localized())
                return
            }
        }
    }
    
    static func unFollow(userId: Int, followServiceDelegate: FollowServiceDelegate?) {
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        let body = ["id": userId] as [String : Any]
        
        Alamofire.request(Global.newBaseURL + "api/user/unSubscribe", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    if followServiceDelegate != nil {
                        followServiceDelegate?.unFollowFinised(success: true, message: "")
                    }
                }
                else {
                    followServiceDelegate?.unFollowFinised(success: false, message: "could_not_connect_to_server_please_try_again".localized())
                }
            case .failure(_):
                followServiceDelegate?.unFollowFinised(success: false, message: "could_not_connect_to_server_please_try_again".localized())
                return
            }
        }
    }
}
