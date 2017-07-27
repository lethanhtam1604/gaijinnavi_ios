//
//  CommentService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/9/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class CommentService: NSObject {
    
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
    
    static func loadCommentList(newId: Int, completion: @escaping (_ success: Bool, _ message: String, _ commentPosts: [CommentPost]) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        var result = [CommentPost]()
        Alamofire.request(Global.newBaseURL + "api/commentsByPostId/" + String(newId), headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                if json["success"].intValue == 1 {
                    let json = JSON(value)
                    let data = json["data"].arrayValue
                    
                    for item in data {
                        let commentPost = CommentPost()
                        commentPost.Avatar = item["Avatar"].stringValue
                        commentPost.DisplayName = item["DisplayName"].stringValue
                        let comment = Comment()
                        comment.Id = item["Comment"]["Id"].intValue
                        comment.PostId = item["Comment"]["PostId"].intValue
                        comment.UserId = item["Comment"]["Comment"]["UserId"].intValue
                        comment.Content = item["Comment"]["Content"].stringValue
                        comment.Avatar = item["Comment"]["Avatar"].stringValue
                        comment.created_time = item["Comment"]["created_time"].stringValue
                        commentPost.comment = comment
                        
                        for likeJson in item["Like"].arrayValue {
                            let like = Like()
                            like.Id = likeJson["Id"].intValue
                            like.CommentId = likeJson["CommentId"].intValue
                            like.UserId = likeJson["UserId"].intValue
                            commentPost.likes.append(like)
                        }
                        result.append(commentPost)
                    }
                    result.sort(by: { $0.comment.created_time < $1.comment.created_time })
                    completion(true, "", result)
                }
            case .failure(_):
                completion(false, "could_not_connect_to_server_please_try_again".localized(), result)
                return
            }
        }
    }
    
    static func likeComment(commentId: Int, userId: Int, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        let body = ["Id": 0, "CommentId" : commentId, "UserId" : userId] as [String : Any]

        Alamofire.request(Global.newBaseURL + "api/like", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                SwiftOverlays.removeAllBlockingOverlays()
                
                let json = JSON(value)
                print(json)
                if json["success"].intValue == 1 {
                    completion(true, "")
                }
                else {
                    completion(false, "could_not_connect_to_server_please_try_again".localized())
                }
            case .failure(_):
                completion(false, "could_not_connect_to_server_please_try_again".localized())
                return
            }
        }
        return
    }
    
    static func postComment(newId: Int, userId: Int, comment: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        let body = ["Id": 0, "PostId": newId, "UserId": userId, "Content": comment] as [String : Any]

        Alamofire.request(Global.newBaseURL + "api/user/postComment", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                SwiftOverlays.removeAllBlockingOverlays()
                let json = JSON(value)
                if json["success"].intValue == 0 {
                    completion(false, "could_not_post_comment_please_try_again".localized())
                }
                else {
                    completion(true, "")
                }
            case .failure(_):
                completion(false, "could_not_post_comment_please_try_again".localized())
            }
        }
    }
}
