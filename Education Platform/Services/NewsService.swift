//
//  NewsService.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 2/7/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

protocol NewsServiceDelegate {
    func loadNewsFinished(success: Bool, message: String, news: [News])
}

class NewsService: NSObject {
    
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
    
    static func getNewsById(newId: Int, completion: @escaping (_ success: Bool, _ message: String, _ news: News?) -> Void) {
   
        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)
        
        Alamofire.request(Global.newBaseURL + "api/news/" + String(newId), headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)

                if json["success"].intValue == 1 {
                    let data = json["data"]
                    
                    let news = News()
                    //newsInterface
                    let newsInterface = NewsInterface()
                    newsInterface.Id = data["newsInterface"]["Id"].intValue
                    newsInterface.Title = data["newsInterface"]["Title"].stringValue
                    newsInterface.Description = data["newsInterface"]["Description"].stringValue
                    newsInterface.DescriptionHtml = data["newsInterface"]["DescriptionHtml"].stringValue
                    newsInterface.ShortDescription = data["newsInterface"]["ShortDescription"].stringValue
                    newsInterface.CategoryId = data["newsInterface"]["CategoryId"].intValue
                    newsInterface.PostType = data["newsInterface"]["PostType"].intValue
                    newsInterface.NewsId = data["newsInterface"]["NewsId"].intValue
                    newsInterface.created_time = data["newsInterface"]["created_time"].stringValue
                    news.newsInterface = newsInterface
                    
                    //photos
                    let photosJson = data["photos"].arrayValue
                    for item in photosJson {
                        let photo = Photo()
                        photo.Id = item["Id"].intValue
                        photo.Title = item["Title"].stringValue
                        photo.Description = item["Description"].stringValue
                        photo.Url = item["Url"].stringValue
                        photo.PostId = item["PostId"].intValue
                        news.photos.append(photo)
                    }
                    
                    //author
                    let author = UserResult()
                    author.Id = data["Authors"]["Id"].intValue
                    author.DisplayName = data["Authors"]["DisplayName"].stringValue
                    author.UserName = data["Authors"]["UserName"].stringValue
                    author.Email = data["Authors"]["Email"].stringValue
                    author.Password = data["Authors"]["Password"].stringValue
                    author.Status = data["Authors"]["Status"].stringValue
                    author.RoleId = data["Authors"]["RoleId"].intValue
                    author.Avatar = data["Authors"]["Avatar"].stringValue
                    author.DOB = data["Authors"]["DOB"].stringValue
                    author.Biography = data["Authors"]["Biography"].stringValue
                    author.Gender = data["Authors"]["Gender"].intValue
                    author.Active = data["Authors"]["Active"].intValue
                    author.Phone = data["Authors"]["Phone"].stringValue
                    author.Address = data["Authors"]["Address"].stringValue
                    author.Token = data["Authors"]["Token"].stringValue
                    news.author = author
                    
                    //category
                    let category = Category()
                    category.Id = data["CategoryInfo"]["Id"].intValue
                    category.Name = data["CategoryInfo"]["Name"].stringValue
                    category.Description = data["CategoryInfo"]["Description"].stringValue
                    news.category = category
                    
                    completion(true, "", news)
                }
            case .failure(_):
                completion(false, "could_not_connect_to_server_please_try_again".localized(), nil)
            }
        }
    }
    
    static func reloadNews(currentPage: Int, newsServiceDelegate: NewsServiceDelegate?) {
        var result = [News]()

        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        Alamofire.request(Global.newBaseURL + "api/news/listnews?currentPage=" + String(currentPage),headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                if json["success"].intValue == 1 {
                    let data = json["data"]["News"].arrayValue
                    for item in data {
                        let news = News()
                        
                        //newsInterface
                        let newsInterface = NewsInterface()
                        newsInterface.Id = item["newsInterface"]["Id"].intValue
                        newsInterface.Title = item["newsInterface"]["Title"].stringValue
                        newsInterface.Description = item["newsInterface"]["Description"].stringValue
                        newsInterface.DescriptionHtml = item["newsInterface"]["DescriptionHtml"].stringValue
                        newsInterface.ShortDescription = item["newsInterface"]["ShortDescription"].stringValue
                        newsInterface.CategoryId = item["newsInterface"]["CategoryId"].intValue
                        newsInterface.PostType = item["newsInterface"]["PostType"].intValue
                        newsInterface.NewsId = item["newsInterface"]["NewsId"].intValue
                        newsInterface.created_time = item["newsInterface"]["created_time"].stringValue
                        news.newsInterface = newsInterface
                        
                        //photos
                        let photosJson = item["photos"].arrayValue
                        for item in photosJson {
                            let photo = Photo()
                            photo.Id = item["Id"].intValue
                            photo.Title = item["Title"].stringValue
                            photo.Description = item["Description"].stringValue
                            photo.Url = item["Url"].stringValue
                            photo.PostId = item["PostId"].intValue
                            news.photos.append(photo)
                        }
                        
                        //author
                        let author = UserResult()
                        author.Id = item["Authors"]["Id"].intValue
                        author.DisplayName = item["Authors"]["DisplayName"].stringValue
                        author.UserName = item["Authors"]["UserName"].stringValue
                        author.Email = item["Authors"]["Email"].stringValue
                        author.Password = item["Authors"]["Password"].stringValue
                        author.Status = item["Authors"]["Status"].stringValue
                        author.RoleId = item["Authors"]["RoleId"].intValue
                        author.Avatar = item["Authors"]["Avatar"].stringValue
                        author.DOB = item["Authors"]["DOB"].stringValue
                        author.Biography = item["Authors"]["Biography"].stringValue
                        author.Gender = item["Authors"]["Gender"].intValue
                        author.Active = item["Authors"]["Active"].intValue
                        author.Phone = item["Authors"]["Phone"].stringValue
                        author.Address = item["Authors"]["Address"].stringValue
                        author.Token = item["Authors"]["Token"].stringValue
                        news.author = author
                        
                        //category
                        let category = Category()
                        category.Id = item["CategoryInfo"]["Id"].intValue
                        category.Name = item["CategoryInfo"]["Name"].stringValue
                        category.Description = item["CategoryInfo"]["Description"].stringValue
                        news.category = category
                        
                        result.append(news)
                    }
                    
                    if newsServiceDelegate != nil {
                        newsServiceDelegate?.loadNewsFinished(success: true, message: "", news: result)
                    }
                }
                else {
                    if newsServiceDelegate != nil {
                        newsServiceDelegate?.loadNewsFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), news: result)
                    }
                }
            case .failure(_):
                if newsServiceDelegate != nil {
                    newsServiceDelegate?.loadNewsFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized() ,news: result)
                }
            }
        }
    }
    
    static func reloadNewsByOwnerUser(currentPage: Int, userId: Int, newsServiceDelegate: NewsServiceDelegate?) {
        var result = [News]()

        setHeader(token: (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!)

        Alamofire.request(Global.newBaseURL + "api/news/listnews?currentPage=" + String(currentPage) + "&userId=" + String(userId), headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if json["success"].intValue == 1 {
                    let data = json["data"]["News"].arrayValue
                    for item in data {
                        let news = News()
                        
                        //newsInterface
                        let newsInterface = NewsInterface()
                        newsInterface.Id = item["newsInterface"]["Id"].intValue
                        newsInterface.Title = item["newsInterface"]["Title"].stringValue
                        newsInterface.Description = item["newsInterface"]["Description"].stringValue
                        newsInterface.DescriptionHtml = item["newsInterface"]["DescriptionHtml"].stringValue
                        newsInterface.ShortDescription = item["newsInterface"]["ShortDescription"].stringValue
                        newsInterface.CategoryId = item["newsInterface"]["CategoryId"].intValue
                        newsInterface.PostType = item["newsInterface"]["PostType"].intValue
                        newsInterface.NewsId = item["newsInterface"]["NewsId"].intValue
                        newsInterface.created_time = item["newsInterface"]["created_time"].stringValue
                        news.newsInterface = newsInterface
                        
                        //photos
                        let photosJson = item["photos"].arrayValue
                        for item in photosJson {
                            let photo = Photo()
                            photo.Id = item["Id"].intValue
                            photo.Title = item["Title"].stringValue
                            photo.Description = item["Description"].stringValue
                            photo.Url = item["Url"].stringValue
                            photo.PostId = item["PostId"].intValue
                            news.photos.append(photo)
                        }
                        
                        //author
                        let author = UserResult()
                        author.Id = item["Authors"]["Id"].intValue
                        author.DisplayName = item["Authors"]["DisplayName"].stringValue
                        author.UserName = item["Authors"]["UserName"].stringValue
                        author.Email = item["Authors"]["Email"].stringValue
                        author.Password = item["Authors"]["Password"].stringValue
                        author.Status = item["Authors"]["Status"].stringValue
                        author.RoleId = item["Authors"]["RoleId"].intValue
                        author.Avatar = item["Authors"]["Avatar"].stringValue
                        author.DOB = item["Authors"]["DOB"].stringValue
                        author.Biography = item["Authors"]["Biography"].stringValue
                        author.Gender = item["Authors"]["Gender"].intValue
                        author.Active = item["Authors"]["Active"].intValue
                        author.Phone = item["Authors"]["Phone"].stringValue
                        author.Address = item["Authors"]["Address"].stringValue
                        author.Token = item["Authors"]["Token"].stringValue
                        news.author = author
                        
                        //category
                        let category = Category()
                        category.Id = item["CategoryInfo"]["Id"].intValue
                        category.Name = item["CategoryInfo"]["Name"].stringValue
                        category.Description = item["CategoryInfo"]["Description"].stringValue
                        news.category = category
                        
                        result.append(news)
                    }
                    
                    if newsServiceDelegate != nil {
                        newsServiceDelegate?.loadNewsFinished(success: true, message: "", news: result)
                    }
                }
                else {
                    if newsServiceDelegate != nil {
                        newsServiceDelegate?.loadNewsFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized(), news: result)
                    }
                }
            case .failure(_):
                if newsServiceDelegate != nil {
                    newsServiceDelegate?.loadNewsFinished(success: false, message: "could_not_connect_to_server_please_try_again".localized() ,news: result)
                }
            }
        }
    }
}
