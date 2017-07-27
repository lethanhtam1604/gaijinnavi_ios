//
//  SchoolData.swift
//  Education Platform
//
//  Created by Duy Cao on 12/15/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit

class School {
    
    var schoolPost = SchoolPost()
    var schoolData = SchoolData()
    var areaDatas = [AreaData]()
    
    var photos = [Photo]()
    var services = [Service]()
    var locationData = Location()
    var contactData = Contact()
    
    func setData(data: SchoolData, post : SchoolPost, LocationData: Location, photos : [Photo]?){
        self.schoolData = data
        self.schoolPost = post
        self.photos = photos == nil ? [Photo]() : photos!
        self.locationData = LocationData
    }
}
