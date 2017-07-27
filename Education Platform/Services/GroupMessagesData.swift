//
//  GroupMessagesData.swift
//  Education Platform
//
//  Created by nquan on 1/13/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Foundation

class GroupMessagesData {

    private static var sharedInstance: GroupMessagesData!
    
    var messages = [GroupResult]()
    
    static func getInstance() -> GroupMessagesData {
        if(sharedInstance == nil) {
            sharedInstance = GroupMessagesData()
        }
        return sharedInstance
    }
    
    private init() {
        
    }
    
    func getCounter() -> Int {
        var total = 0
        for message in self.messages {
            let count = message.UnSeen
            if( count > 0)
            {
                total += 1
            }
        }
       return total
    }


}



