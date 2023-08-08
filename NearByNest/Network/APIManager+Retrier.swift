//
//  APIManager+Retrier.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Foundation
import Alamofire

class APIManagerRetrier: RequestRetrier {
    
    // MARK: Vars & Lets
    
    var numberOfRetries = 0
    var refreshTokenViewModel = RefreshTokenViewModel()
    
    // MARK: Request Retrier methods
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if (error.localizedDescription == "The operation couldn’t be completed. Software caused connection abort") {
            completion(true, 1.0) // retry after 1 second
            self.numberOfRetries += 1
        } else if let response = request.task?.response as? HTTPURLResponse, response.statusCode >= 500, self.numberOfRetries < 3 {
            completion(true, 1.0) // retry after 1 second
            self.numberOfRetries += 1
        } else if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, self.numberOfRetries < 3 {
            let reqURL = request.task?.currentRequest?.url?.absoluteString ?? ""
            refreshTokenViewModel.isSuccess.bind { (isSuccess) in
                if isSuccess {
                    completion(true, 1.0)
                } else {
                    completion(false, 0.0)
                }
            }
            if userManager.isUserLogin && !(reqURL.contains(RequestItemsType.refreshToken.path)) {
                refreshTokenViewModel.callRefreshToken()
                self.numberOfRetries += 1
            } else {
                completion(false, 0.0)
            }
             // retry after 2 second, mean while token will be updated from backend
        } else {
            completion(false, 0.0) // don't retry
            self.numberOfRetries = 0
        }
    }
    
}
