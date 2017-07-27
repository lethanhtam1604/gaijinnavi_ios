//
//  WebSocketServices.swift
//  Education Platform
//
//  Created by nquan on 12/26/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

class WebSocketServices : WebSocketDelegate
{
    static let shared = WebSocketServices()
    
    var socket:WebSocket?
    
    var activeUsers:[Int64]?
    
    func Connect(UserId: Int, Token: String) {
        ChatAPIservices.getToken() {
            chatToken in
            if let token = chatToken {
                let url = Global.socketURL + "?token=" + token + "&userId=\(UserId)"
                self.socket = WebSocket(url: URL(string: url)!)
                self.socket?.delegate = self
                self.activeUsers = [Int64]()
                self.socket?.connect()
                ChatAPIservices.loadBagdeMessage()
            }
            else {
                self.Disconnect()
            }
        }
    }
    
    func Disconnect() {
        socket?.disconnect()
        socket = nil
        activeUsers = nil
    }
    
    func getActiveUser() {
        let json:JSON = ["Action":"GET_ACTIVE_USER"]
        self.Write(message: json.rawString()!)
    }
    
    func IsConnect() -> Bool {
        return socket?.isConnected ?? false
    }
    
    func Write(message: String) {
        if let socket = self.socket {
            if(!self.IsConnect()) {
                return
            }
            socket.write(string: message);
        }
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("Connect WebSocket")
        self.getActiveUser()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("Disconnect WebSocket \(error))")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        if text != "" {
            let json = JSON.parse(text)
            let type = json["Type"].stringValue
            let message = json["Message"].stringValue
            let groupId = json["GroupId"].stringValue
            let UserId  = json["User"].stringValue
            
            switch type {
            case "SEND_MESSAGE":
                let info:[String: Any] = ["Message": message, "UserId" : UserId, "groupId": groupId];
                ChatAPIservices.loadBagdeMessage()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKETISRECEIVED"), object: nil, userInfo: info)
                
                break
            case "TYPING":
                let info:[String: Any] = ["UserId" : UserId, "groupId": groupId];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKETISTYPING"), object: nil, userInfo: info)
                break
            case "GET_ACTIVE_USER":
                let users = json["Users"].arrayValue
                if (activeUsers != nil) {
                    for user in users {
                        activeUsers?.append(user.int64!)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_LOGIN_LOGOUT"), object: nil, userInfo: nil)
                break
            case "login":
                let user = json["User"].int64
                activeUsers?.append(user!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_LOGIN_LOGOUT"), object: nil, userInfo: nil)
                break
            case "logout":
                let user = json["User"].int64
                activeUsers = activeUsers?.filter(){$0 != user}
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_LOGIN_LOGOUT"), object: nil, userInfo: nil)
                break
            case "ADD_FRIEND_REQUEST":
                let info:[String: Any] = ["UserId" : json["UserId"].int64Value]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_ADD_FRIEND_REQUEST"), object: nil, userInfo: info)
                break
            case "ACCEPT_FRIEND_REQUEST":
                let info:[String: Any] = ["UserId" : json["UserId"].int64Value]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_ACCEPT_FRIEND_REQUEST"), object: nil, userInfo: info)
                break
            case "DECLINE_FRIEND_REQUEST":
                let info:[String: Any] = ["UserId" : json["UserId"].int64Value]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_DECLINE_FRIEND_REQUEST"), object: nil, userInfo: info)
                break
            case "ACCEPT_FRIEND_REQUEST_RESPONSE":
                let info:[String: Any] = ["Success" : json["Success"].intValue]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_ACCEPT_FRIEND_REQUEST_RESPONSE"), object: nil, userInfo: info)
                break
            case "DECLINE_FRIEND_REQUEST_RESPONSE":
                let info:[String: Any] = ["Success" : json["Success"].intValue]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_DECLINE_FRIEND_REQUEST_RESPONSE"), object: nil, userInfo: info)
                break
            case "ADD_FRIEND_REQUEST_RESPONSE":
                let info:[String: Any] = ["Success" : json["Success"].intValue]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SOCKET_ADD_FRIEND_REQUEST_RESPONSE"), object: nil, userInfo: info)
                break
            default:
                break
            }
            
        }
        else {
            
            print("Receiver Socket Error")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        
    }
}
