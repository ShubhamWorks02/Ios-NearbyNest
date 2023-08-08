//
//  APIManager+BaseJson.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Foundation

/// This is base json model of codable type
/// In throught app response base model will be same.
class BaseJsonModel<T: Codable>: Codable {
    let status: Bool
    let data: T
}
