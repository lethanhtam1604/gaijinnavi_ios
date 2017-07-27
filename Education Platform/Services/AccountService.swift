//
//  AccountService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/14/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class AccountService: NSObject {
    
    static func getUser(completion: @escaping (_ roleResult: RoleResult?) -> Void) {
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]

        Alamofire.request(Global.newBaseURL + "account/user", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["succes"].intValue == 1 {
                    
                    let roleResult = RoleResult()
                    roleResult.User.Id = json["data"]["User"]["Id"].intValue
                    roleResult.User.DisplayName = json["data"]["User"]["DisplayName"].stringValue
                    roleResult.User.Email = json["data"]["User"]["Email"].stringValue
                    roleResult.User.DOB = json["data"]["User"]["DOB"].stringValue
                    roleResult.User.Gender = json["data"]["User"]["Gender"].intValue
                    roleResult.User.Biography = json["data"]["User"]["Biography"].stringValue
                    roleResult.User.Avatar = json["data"]["User"]["Avatar"].stringValue
                    roleResult.User.Phone = json["data"]["User"]["Phone"].stringValue
                    roleResult.User.Address = json["data"]["User"]["Address"].stringValue
                    roleResult.User.NameFurigana = json["data"]["User"]["NameFurigana"].stringValue
                    roleResult.User.Nationality = json["data"]["User"]["Nationality"].stringValue
                    
                    completion(roleResult)
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

    static func login(email: String, password: String, remember: Bool, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["email": email, "password": password, "rememberMe": remember] as [String : Any]
        
        Alamofire.request(Global.newBaseURL + "signIn", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 0 {
                    completion(false, "email_or_password_is_incorrect".localized())
                }
                else {
                    let token = json["data"]["token"].stringValue
                    let headers: HTTPHeaders = ["X-Auth-Token": token]

                    Alamofire.request(Global.newBaseURL + "account/user", headers: headers).responseJSON { response in
                        SwiftOverlays.removeAllBlockingOverlays()
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                        
                            let roleResult = RoleResult()
                            roleResult.User.rememberMe = remember
                            roleResult.User.Id = json["data"]["User"]["Id"].intValue
                            roleResult.User.DisplayName = json["data"]["User"]["DisplayName"].stringValue
                            roleResult.User.Email = json["data"]["User"]["Email"].stringValue
                            roleResult.User.Token = token
                            roleResult.User.DOB = json["data"]["User"]["DOB"].stringValue
                            roleResult.User.Gender = json["data"]["User"]["Gender"].intValue
                            roleResult.User.Password = password
                            
                            UserDefaultManager.getInstance().setCurrentUser(roleResult: roleResult)
                            completion(true, "")
                        case .failure(_):
                            completion(false, "could_not_connect_to_server_please_try_again".localized())
                        }
                    }
                }
            case .failure(_):
                completion(false, "could_not_connect_to_server_please_try_again".localized())
            }
        }
    }

    static func signup(userResult: UserResult, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "lang": "jp"]
        let body = ["DisplayName": userResult.DisplayName, "Email": userResult.Email, "DOB": userResult.DOB, "Gender": userResult.Gender, "password": userResult.Password] as [String : Any]
        
        Alamofire.request(Global.newBaseURL + "signUp", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 0 {
                    completion(false, "email_already_exists_please_try_again".localized())
                }
                else {
                    let token = json["data"]["token"].stringValue
                    let headers: HTTPHeaders = ["X-Auth-Token": token]
                    
                    Alamofire.request(Global.newBaseURL + "account/user", headers: headers).responseJSON { response in
                        SwiftOverlays.removeAllBlockingOverlays()
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            
                            let roleResult = RoleResult()
                            roleResult.User.Id = json["data"]["User"]["Id"].intValue
                            roleResult.User.DisplayName = json["data"]["User"]["DisplayName"].stringValue
                            roleResult.User.Email = json["data"]["User"]["Email"].stringValue
                            roleResult.User.Token = token
                            roleResult.User.DOB = userResult.DOB
                            roleResult.User.Gender = userResult.Gender
                            roleResult.User.Password = userResult.Password
                            roleResult.User.rememberMe = true

                            UserDefaultManager.getInstance().setCurrentUser(roleResult: roleResult)
                            completion(true, "Please check email " + roleResult.User.Email + " to verify your account!")
                        case .failure(_):
                            completion(false, "could_not_connect_to_server_please_try_again".localized())
                        }
                    }
                }
            case .failure(_):
                completion(false, "could_not_connect_to_server_please_try_again".localized())
            }
        }
    }
    
    static func loginSocial(token: String, type: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["AccessToken": token, "TokenType": "", "ExpiresIn": 0, "RefreshToken": ""] as [String : Any]
        
        Alamofire.request(Global.newBaseURL + "authenticateToken/" + type, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 0 {
                    completion(false, "could_not_login_because_your_email_account_has_been_security".localized())
                }
                else {
                    let token = json["data"]["token"].stringValue
                    let roleResult = RoleResult()
                    roleResult.User.Token = token
                    UserDefaultManager.getInstance().setCurrentUser(roleResult: roleResult)

                    AccountService.getUser() {
                        newUser in
                        newUser?.User.Token = token
                        UserDefaultManager.getInstance().setCurrentUser(roleResult: newUser)
                        completion(true, "")
                    }
                }
            case .failure(_):
                completion(false, "could_not_login_because_your_email_account_has_been_security".localized())
            }
        }
    }
    
    static func checkAccountConfirmation(completion: @escaping (_ result: Bool) -> Void) {
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]
        
        Alamofire.request(Global.newBaseURL + "account/activate/email/check", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                if json["success"].intValue == 1 {
                    completion(true)
                }
                else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
                return
            }
        }
    }

    
    static func resentEmail(email: String, completion: @escaping (_ result: Bool?) -> Void) {
        let headers: HTTPHeaders = ["lang": "jp"]
        
        Alamofire.request(Global.newBaseURL + "account/email/" + email, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    completion(true)
                }
                else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
                return
            }
        }
    }

}
