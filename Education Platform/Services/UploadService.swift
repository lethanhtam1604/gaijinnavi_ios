//
//  UploadService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/8/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol UploadServiceDelegate {
    func uploadImageFinished(success: Bool, message: String, data: String)
}

class UploadService: NSObject {
    
    static var headers: HTTPHeaders!
    
    static func setHeader(token: String) {
        headers = ["X-Auth-Token": token]
    }

    static func uploadImage(image: Data, uploadServiceDelegate: UploadServiceDelegate?) {
        
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "picture", fileName: "photo.jpeg", mimeType: "image/jpeg")
                
        }, to: Global.newBaseURL + "api/image/uploads",
           method: .post,
           headers: headers,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.data!)
                    if json["success"].intValue == 1 {
                        if uploadServiceDelegate != nil {
                            uploadServiceDelegate?.uploadImageFinished(success: true, message: "" ,data: json["data"].stringValue)
                        }
                    }
                    else {
                        if uploadServiceDelegate != nil {
                            uploadServiceDelegate?.uploadImageFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized() ,data: "")
                        }
                    }
                }
            case .failure(_):
                if uploadServiceDelegate != nil {
                    uploadServiceDelegate?.uploadImageFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized() ,data: "")
                }
            }
        })
    }
}
