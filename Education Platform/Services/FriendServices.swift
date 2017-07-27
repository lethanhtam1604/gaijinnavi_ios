//
//  FriendServices.swift
//  Education Platform
//
//  Created by nquan on 2/8/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Foundation

class FriendServices {

    private static var sharedInstance: FriendServices?
    
    var friendList = [ChatUserResult]()
    var waitingMeList = [ChatUserResult]()
    var waitingThemList = [ChatUserResult]()
    var NoFriend = [ChatUserResult]()
    
    static func getInstance() -> FriendServices {
        if(sharedInstance == nil) {
            sharedInstance = FriendServices()
        }
        return sharedInstance!
    }
    
    init() {

    }
    
    func getDataUser(){
        friendList = [ChatUserResult]()
        waitingMeList = [ChatUserResult]()
        waitingThemList = [ChatUserResult]()
        NoFriend = [ChatUserResult]()
        
        ChatAPIservices.getAllAgency(RelationID: 3) { (data) in
            self.friendList.append(contentsOf: data)
            ChatAPIservices.getAllAgency(RelationID: 2, completion: { (data2) in
                self.waitingMeList.append(contentsOf: data2)
                ChatAPIservices.getAllAgency(RelationID: 1, completion: { (data3) in
                    self.waitingThemList.append(contentsOf: data3)
                    ChatAPIservices.getAllAgency(RelationID: 0, completion: { (data4) in
                        self.NoFriend.append(contentsOf: data4)
                    
                    })
                    
                })
            })
        }
    }
    
    func isListContainUser(list: [ChatUserResult],UserId: Int64) -> Bool {
        for each in list {
        if each.Id == UserId {
            return true
            }
        }
        return false
    }
    
    func checkUserStatus(UserId: Int64) -> Int {
        if isListContainUser(list: friendList, UserId: UserId) {
            return 3
        } else if isListContainUser(list: waitingMeList, UserId: UserId) {
            return 2
        } else if isListContainUser(list: waitingThemList, UserId: UserId) {
            return 1
        } else {
            return 0
        }
    }
    
    func removeAllFriendList() {
        friendList = [ChatUserResult]()
        waitingMeList = [ChatUserResult]()
        waitingThemList = [ChatUserResult]()
        NoFriend = [ChatUserResult]()
    }
}
