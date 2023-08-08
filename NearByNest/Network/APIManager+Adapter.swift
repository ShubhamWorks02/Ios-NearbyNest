//
//  APIManager+Adapter.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import UIKit
import Alamofire

class APIManagerAdapter: RequestAdapter {

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var newRequest = urlRequest
        newRequest.setValue("Bearer \(userManager.accessToken)", forHTTPHeaderField: APIParams.Authentication.authorization)
        return newRequest
    }

}
