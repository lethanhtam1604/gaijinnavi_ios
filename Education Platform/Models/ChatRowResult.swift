//
//  ChatRowResult.swift
//  Education Platform
//
//  Created by nquan on 12/26/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import Foundation

class ChatRowResult {
    
    var Id:Int64 = 0
    var User = ChatUserResult()
    var Message = ""
    var GroupId = ""
    var SeenFlag = 0
    var updated_time = ""
}
