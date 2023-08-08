//
//  APIManager.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Alamofire
import UIKit
import Reachability

class APIManager: NetworkManger {
    
    // MARK: Vars & Lets
    let reachability = try? Reachability()
    private let sessionManager: SessionManager
    private let retrier: APIManagerRetrier
    private let adapter: APIManagerAdapter
    static let errorCodeList =  [400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 425, 426, 427, 428, 429, 431, 451, 500, -1009, -1001]
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: Public methods
    static var shared: APIManager {
        return APIManager(sessionManager: SessionManager(), retrier: APIManagerRetrier(), adapter: APIManagerAdapter())
    }
    
    func call(type: RequestItemsType, params: Parameters?, handler: @escaping (Swift.Result<(), CustomError>) -> Void) {
        if reachability?.connection ?? .none != .none {
            self.sessionManager.request(type.url,
                                        method: type.httpMethod,
                                        parameters: params,
                                        encoding: type.encoding,
                                        headers: type.headers).validate().responseJSON { (data) in
                                            if self.handleResponseCode(res: data) {
                                                switch data.result {
                                                case .success:
                                                    handler(.success(()))
                                                case .failure:
                                                    handler(.failure(self.parseApiError(dataResponse: data)))
                                                }
                                            } else {
                                                handler(.failure(self.parseApiError(dataResponse: data)))
                                            }
                                        }
        } else {
            handler(.failure(CustomError(title: R.string.localizable.appName(), body: APIError.noInternet)))
        }
    }
    
    func call<T>(type: RequestItemsType, params: Parameters? = nil, handler: @escaping (Swift.Result<T, CustomError>) -> Void) where T: Codable {
        if reachability?.connection ?? .unavailable != .unavailable {
            self.sessionManager.request(type.url,
                                        method: type.httpMethod,
                                        parameters: params,
                                        encoding: type.encoding,
                                        headers: type.headers).validate().responseJSON { (data) in
                                            if self.handleResponseCode(res: data) {
                                                do {
                                                    guard let jsonData = data.data else {
                                                        throw CustomError(title: APIError.defaultAlertTitle, body: APIError.noData)
                                                    }
                                                    let result = try JSONDecoder().decode(T.self, from: jsonData)
                                                    handler(.success(result))
                                                    self.resetNumberOfRetries()
                                                } catch {
                                                    if let error = error as? CustomError {
                                                        return handler(.failure(error))
                                                    }
                                                    handler(.failure(self.parseApiError(dataResponse: data)))
                                                }
                                            } else {
                                                handler(.failure(self.parseApiError(dataResponse: data)))
                                            }
                                        }
        } else {
            handler(.failure(CustomError(title: R.string.localizable.appName(), body: APIError.noInternet)))
        }
    }
    
    func call(type: RequestItemsType, params: Parameters? = nil, handler: @escaping (Swift.Result<Data, CustomError>) -> Void) {
        if reachability?.connection ?? .unavailable != .unavailable {
            
            self.sessionManager.request(type.url,
                                        method: type.httpMethod,
                                        parameters: params,
                                        encoding: type.encoding,
                                        headers: type.headers).validate().responseJSON { (data) in
                                            if self.handleResponseCode(res: data) {
                                                do {
                                                    guard let jsonData = data.data else {
                                                        throw CustomError(title: APIError.defaultAlertTitle, body: APIError.noData)
                                                    }
                                                    handler(.success(jsonData))
                                                    self.resetNumberOfRetries()
                                                } catch {
                                                    if let error = error as? CustomError {
                                                        return handler(.failure(error))
                                                    }
                                                    handler(.failure(self.parseApiError(dataResponse: data)))
                                                }
                                            } else {
                                                handler(.failure(self.parseApiError(dataResponse: data)))
                                            }
                                        }
        } else {
            handler(.failure(CustomError(title: R.string.localizable.appName(), body: APIError.noInternet)))
        }
    }
    
    // MARK: Private methods
    
    private func resetNumberOfRetries() {
        self.retrier.numberOfRetries = 0
    }
    
    /// Handle response code
    ///
    /// - Parameter res: api response
    /// - Returns: returns true if response status is sucess else false
    private func handleResponseCode(res: DataResponse<Any>?) -> Bool {
        var isSuccess: Bool = false
        
        guard let dataResponse = res else {
            return isSuccess
        }
        guard let response = dataResponse.response else {
            return isSuccess
        }
        
        switch response.statusCode {
        case 200...300:
            isSuccess = true
        default: break
        }
        
        return isSuccess
    }
    
    // MARK: Initialization
    
    init(sessionManager: SessionManager, retrier: APIManagerRetrier, adapter: APIManagerAdapter) {
        self.sessionManager = sessionManager
        self.retrier = retrier
        self.sessionManager.retrier = self.retrier
        self.adapter = adapter
        self.sessionManager.adapter = adapter
    }
    
}
