//
//  GroupResult.swift
//  Education Platform
//
//  Created by nquan on 12/26/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import Foundation

class GroupResult {

    var Id:String = ""
    var LastMessage = ""
    var LastUid:Int64 = 0
    var updated_time = ""
    var UnSeen = 0
    var Users = [ChatUserResult]()
}
