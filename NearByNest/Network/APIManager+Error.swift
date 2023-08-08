//
//  APIManager+Error.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Foundation

class CustomError: Error {

    // MARK: Vars & Lets
    var title = ""
    var body = ""

    // MARK: Intialization
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }

}

class NetworkError: Codable {

    let message: String
    let code: Int?

}
