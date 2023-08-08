//
//  SessionModel.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Foundation

class SessionModel: Codable {
    
    var accessToken: String?
    var tokenType: String?
    var refreshToken: String?
    var expiresIn: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "accessToken"
        case tokenType = "tokenType"
        case refreshToken = "refreshToken"
        case expiresIn = "expiresIn"
    }

}
