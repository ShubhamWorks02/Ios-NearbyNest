//
//  APIManager+FakeDataProvider.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Alamofire
import UIKit
import Reachability

/// Provide fake data to controller
class FakeDataProvider: NetworkManger {
    
    func call<T>(type: RequestItemsType, params: Parameters?, handler: @escaping (Swift.Result<T, CustomError>) -> Void) where T: Codable {
        handler(.failure(CustomError(title: R.string.localizable.appName(), body: APIError.noData)))
    }
    
}
