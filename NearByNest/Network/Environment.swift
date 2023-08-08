//
//  Environment.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Foundation

/// AppConstant
public struct AppConstant {
    static let environment = Environment()
    static let serverURL = environment.configuration(PlistKey.serverURL) as? String ?? ""
    static let clientId = environment.configuration(PlistKey.clientId) as? String ?? ""
    static let clientSecret = environment.configuration(PlistKey.clientSecret) as? String ?? ""
    static let authURI = environment.configuration(PlistKey.authURI) as? String ?? ""
    static let tokenURI = environment.configuration(PlistKey.tokenURI) as? String ?? ""
    static let authBaseURL = environment.configuration(PlistKey.authBaseURL) as? String ?? ""
    static let appID = environment.configuration(PlistKey.appID) as? String ?? ""
    static let isEnviromentLocal = environment.configuration(PlistKey.isEnviromentLocal) as? Bool ?? false
}

/// PlistKey
public enum PlistKey {
    
    case serverURL
    case clientId
    case clientSecret
    case authURI
    case tokenURI
    case appID
    case authBaseURL
    case isEnviromentLocal
    
    func value() -> String {
        switch self {
        case .serverURL:
            return "ServerURL"
        case .isEnviromentLocal:
            return "isEnviromentLocal"
        case .clientId:
            return "clientId"
        case .clientSecret:
            return "clientSecret"
        case .authURI:
            return "authURI"
        case .tokenURI:
            return "tokenURI"
        case .appID:
            return "appID"
        case .authBaseURL:
            return "authBaseURL"
        }
    }
    
}

/// Environment
public struct Environment {
    
    /// fetch data from info.plist
    fileprivate var infoDict: [String: Any] {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    /// Provide value from info.plist file
    ///
    /// - Parameter key: Needed key
    /// - Returns: Get value in define datatype(Any you type cast later)
    func configuration(_ key: PlistKey) -> Any {
        switch key {
        case .serverURL:
            return infoDict[PlistKey.serverURL.value()] as? String ?? ""
        case .isEnviromentLocal:
            return infoDict[PlistKey.isEnviromentLocal.value()] as? Bool ?? false
        case .clientId:
            return infoDict[PlistKey.clientId.value()] as? String ?? ""
        case .clientSecret:
            return infoDict[PlistKey.clientSecret.value()] as? String ?? ""
        case .authURI:
            return infoDict[PlistKey.authURI.value()] as? String ?? ""
        case .tokenURI:
            return infoDict[PlistKey.tokenURI.value()] as? String ?? ""
        case .appID:
            return infoDict[PlistKey.appID.value()] as? String ?? ""
        case .authBaseURL:
            return infoDict[PlistKey.authBaseURL.value()] as? String ?? ""
        }
    }
    
}
