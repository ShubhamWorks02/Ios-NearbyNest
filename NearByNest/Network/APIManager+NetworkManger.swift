//
//  APIManager+NetworkManger.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Alamofire
import UIKit
import Reachability

/// Network Manger call the register data provide calls data provider methods
protocol NetworkManger {
    
    func call<T>(type: RequestItemsType, params: Parameters?, handler: @escaping (Swift.Result<T, CustomError>) -> Void) where T: Codable
}
