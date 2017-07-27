//
//  ChatServices.swift
//  Education Platform
//
//  Created by nquan on 12/26/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ChatAPIservices {
    
    static func getToken(completion: @escaping (_ chatToken: String?) -> Void) {
        
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]
        
        Alamofire.request(Global.newBaseURL + "api/go/chat", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    let token = json["data"].stringValue
                    completion(token)
                }
                else {
                    completion(nil)
                }
            case .failure(_):
                completion(nil)
                return
            }
        }
        
        
    }
    
    static func getAllAgency(RelationID: Int?,completion: @escaping (_ userData: [ChatUserResult]) -> Void) {
        let parameter:Parameters?
        if(RelationID == nil) {
            parameter = nil
        }
        else {
            parameter = ["RelationId": RelationID!]
        }
        
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]
        
        Alamofire.request(Global.newBaseURL + "api/chat/users", method: .get, parameters: parameter, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success( _):
                let UserResult = [ChatUserResult](data: response.data!)
                completion(UserResult)
                break
            case .failure(_):
                completion([ChatUserResult]())
                break
            }
        }
    }
    
    static func getChatbyGroupId(CurrentPage: Int, PageSize: Int, GroupId: String, completion: @escaping (_ userData: MessageResult) -> Void) {
        let body:Parameters = ["CurrentPage": CurrentPage, "PageSize": PageSize] as [String : Any]
        
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]
        
        Alamofire.request(Global.newBaseURL + "api/chats/\(GroupId)", method: .get, parameters: body, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json =  JSON(value)
                let messagesResult = MessageResult()
                
                messagesResult.PageSize = json["PageSize"].intValue
                messagesResult.CurrentPage = json["CurrentPage"].intValue
                messagesResult.TotalPage = json["TotalPage"].intValue
                
                let messages = json["Messages"].arrayValue
                
                for  message in messages
                {
                    let chatRowResult = ChatRowResult()
                    
                    chatRowResult.Id = message["Id"].int64Value
                    chatRowResult.Message = message["Message"].stringValue
                    chatRowResult.SeenFlag = message["SeenFlag"].intValue
                    chatRowResult.GroupId =  message["GroupId"].stringValue
                    chatRowResult.updated_time = message["updated_time"].stringValue
                    
                    let user = ChatUserResult(json: message["User"].rawString())
                    chatRowResult.User = user
                    messagesResult.Messages.append(chatRowResult)
                }
                
                completion(messagesResult)
                break
                
            case .failure(_):
                print("get user Error ")
                break
            }
        }
    }
    
    static func getGroupContainUser(completion: @escaping (_ userData: [GroupResult]) -> Void) {
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]

        Alamofire.request(Global.newBaseURL +  "api/chat/group", headers: headers).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var groupResult = [GroupResult]()
                for group in json["groups"].arrayValue {
                    let data = GroupResult()
                    data.Id = group["Id"].stringValue
                    data.LastMessage = group["LastMessage"].stringValue
                    data.LastUid = group["LastUid"].int64Value
                    data.updated_time = group["updated_time"].stringValue
                    data.UnSeen = group["UnSeen"].intValue
                    for user in group["Users"].arrayValue {
                        let user = ChatUserResult(json: user.rawString())
                        data.Users.append(user)
                    }
                    groupResult.append(data)
                }
                completion(groupResult)
                break
            case .failure( _):
                completion([GroupResult]())
                break
            }
        }
        
    }
    
    static func createChatGroup(UserIds: [Int64], completion: @escaping (_ Success: Bool, _ data: String?) -> Void ) {
        
        var request = URLRequest(url: URL(string: Global.newBaseURL + "api/chat/group")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue((UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!, forHTTPHeaderField: "X-Auth-Token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: UserIds)
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let success = json["success"].intValue
                let data  = json["data"].stringValue
                if ( success == 1) {
                    completion(true,data)
                }
                else {
                    completion(false,data)
                }
                print("Create group Success")
                break
            case .failure(let error):
                
                print("Create Chat group Fail \(error)")
                completion(false, nil)
                break
            }
        }
        
    }
    
    static func UpdateGroup(groupID:String,lastMessage: String, LastUId: Int64, completion: @escaping (_ Success: Bool) -> Void ) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json", "X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]
        let body = ["Id":groupID, "LastMessage":lastMessage,"LastUid":LastUId,"Users":NSNull(),"UnSeen":0,"Description":"Chien di"] as [String : Any]
        
        Alamofire.request(Global.newBaseURL + "api/chat/group", method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let success = json["success"].intValue
                if ( success == 1)
                {
                    completion(true)
                }
                else {
                    completion(false)
                }
                print("Update Chat OK \(JSON(value))")
                break
            case .failure(let error):
                print("Update Chat Error \(error)")
                completion(false)
                break
            }
        }
    }
    
    static func seenGroup(groupId: String, completion: @escaping (_ Success: Bool) -> Void ) {
        
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]

        Alamofire.request(Global.newBaseURL + "api/chat/group/seen/\(groupId)", method: .get , parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let success = json["success"].intValue
                if ( success == 1) {
                    completion(true)
                }
                else {
                    completion(false)
                }
                print("Seen OK \(JSON(value))")
                break
            case .failure(let error):
                print("Seen fail \(error)")
                completion(false)
                break
            }
        }
        
    }
    
    static func getUsersSameGroup(groupId: String, completion: @escaping (_ : [ChatUserResult]) -> Void ) {
        
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]

        Alamofire.request(Global.newBaseURL + "api/chat/group/\(groupId)/users", method: .get , parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                let UserResult = [ChatUserResult](data: response.data!)
                completion(UserResult)
                
                print("Get user Chat Success")
                break
                
            case .failure(_):
                print("get user Error ")
                break
            }
        }
    }
    
    static func loadBagdeMessage() {
        ChatAPIservices.getGroupContainUser { (groups) in
            GroupMessagesData.getInstance().messages.removeAll(keepingCapacity: true)
            GroupMessagesData.getInstance().messages =  groups
            
            let total = GroupMessagesData.getInstance().getCounter()
            Utils.setBadgeIndicator(badgeCount: total)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_BADEGE_RECEIVED"), object: nil, userInfo: nil)
        }
    }
}
