//
//  ArrayParamEncoding.swift
//  Education Platform
//
//  Created by Duy Cao on 1/20/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Alamofire

struct ArrayParamEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
        return request
    }
}
