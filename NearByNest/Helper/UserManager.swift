//
//  UserManager.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//

import Foundation
import Alamofire

private struct AppConstants {
    // NSUserDefaults persistence keys
    static let isUserLogin = "isUserLogin"
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    static let accessCode = "accessCode"
    static let deviceToken = "deviceToken"
    static let notificationPermission = "notificationPermission"
    static let isFirstTimeLaunch = "isFirstTimeLaunch"
    static let isPushEnable = "isPushEnable"
    static let pushPlayerID = "pushPlayerID"
}

private struct UserConstants {
    // NSUserDefaults persistence keys
    static let addressline1 = "addressline1"
    static let organizationBaseURL = "organizationBaseURL"
    static let organizationHost = "organizationHost"
}

let userManager = UserManager.shared

internal class UserManager {
    
    // static properties get lazy evaluation and dispatch_once_t for free
    private struct Static {
        static let instance = UserManager()
    }
    
    // this is the Swift way to do singletons
    class var shared: UserManager {
        return Static.instance
    }
    
    // user authentication always begins with a UUID
    private let userDefaults = UserDefaults.standard
    
    let dateFormatter = DateFormatter()
    
    // username etc. are backed by NSUserDefaults, no need for further local storage
    
    var httpTokenHeader: [String: String]? {
        get {
            return ["Accept": "application/json", "Authorization": !(userManager.accessToken.isEmpty) ? "Bearer \(userManager.accessToken)" : "", "Content-Type": "application/json"]
        }
    }
    
    var httpPreTokenHeader: [String: String]? {
        get {
            return ["Accept": "application/json"]
        }
    }
    
    // check isUserLogin
    var isUserLogin: Bool {
        get {
            return userDefaults.object(forKey: AppConstants.isUserLogin) as? Bool ?? false
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.isUserLogin)
            userDefaults.synchronize()
        }
    }
    
    // user token data
    var accessToken: String {
        get {
            return userDefaults.object(forKey: AppConstants.accessToken) as? String ?? ""
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.accessToken)
            userDefaults.synchronize()
        }
    }
    
    // user refresh token data
    var refreshToken: String {
        get {
            return userDefaults.object(forKey: AppConstants.refreshToken) as? String ?? ""
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.refreshToken)
            userDefaults.synchronize()
        }
    }
    
    // user access code data for auth 2.0 sigin
    var accessCode: String {
        get {
            return userDefaults.object(forKey: AppConstants.accessCode) as? String ?? ""
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.accessCode)
            userDefaults.synchronize()
        }
    }
    
    // user deviceToken token data
    var deviceToken: String {
        get {
            return userDefaults.object(forKey: AppConstants.deviceToken) as? String ?? ""
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.deviceToken)
            userDefaults.synchronize()
        }
    }
    
    // user pushPlayerId token data
    var pushPlayerID: String {
        get {
            return userDefaults.object(forKey: AppConstants.pushPlayerID) as? String ?? ""
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.pushPlayerID)
            userDefaults.synchronize()
        }
    }
    
    // check is notification permission screen show or not
    var isNotificationPermissionShow: Bool {
        get {
            return userDefaults.object(forKey: AppConstants.notificationPermission) as? Bool ?? false
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.notificationPermission)
            userDefaults.synchronize()
        }
    }
    
    // check is app launch first time
    var isFirstTimeLaunch: Bool {
        get {
            return userDefaults.object(forKey: AppConstants.isFirstTimeLaunch) as? Bool ?? true
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.isFirstTimeLaunch)
            userDefaults.synchronize()
        }
    }

    // check is push enable or not
    var isPushEnable: Bool {
        get {
            return userDefaults.object(forKey: AppConstants.isPushEnable) as? Bool ?? true
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: AppConstants.isPushEnable)
            userDefaults.synchronize()
        }
    }
    
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // check isOrganizationBaseURL
    var organizationBaseURL: String {
        get {
            return userDefaults.object(forKey: UserConstants.organizationBaseURL) as? String ?? AppConstant.authBaseURL
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: UserConstants.organizationBaseURL)
            userDefaults.synchronize()
        }
    }
    
    var organizationHost: String {
        get {
            return userDefaults.object(forKey: UserConstants.organizationHost) as? String ?? ""
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: UserConstants.organizationHost)
            userDefaults.synchronize()
        }
    }
        
}

extension UserManager {
    
    // MARK: clearAllData
    func clearAllData() {
        
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }
    
}

extension UserDefaults {
    
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}
