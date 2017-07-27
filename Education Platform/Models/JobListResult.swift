//
//  JobListResult.swift
//  Education Platform
//
//  Created by nquan on 2/20/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import Foundation

class JobListResult {
    var JobData = JobResult()
    var PostData = SchoolPost()
    var CompanyData = CompanyResult()
    var BenefitsData = [BenefitsResult]()
    var LocationData = Location()
    var AuthorData = AuthorResult()
    var PhotoData = [Photo]()
    var contactData = ContactData()
    var JobType = JobTypeResult()
    var tagDatas = [TagData]()
    var major = Major()
}
