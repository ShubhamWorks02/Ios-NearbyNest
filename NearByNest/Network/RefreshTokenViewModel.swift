//
//  RefreshTokenViewModel.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Foundation

class RefreshTokenViewModel {
    
    var isSuccess: LiveData<Bool> = LiveData(true)

    func callRefreshToken() {
        let params: [String: Any] = [APIParams.Authentication.refreshToken: userManager.refreshToken]
        APIManager.shared.call(type: .refreshToken, params: params) { [weak self] (result: Swift.Result<SessionModel, CustomError>) in
            guard let uSelf = self else {
                return
            }
            switch result {
            case .success:
                // TODO: save token.
                uSelf.isSuccess.value = true
            case .failure(let error):
                prints(error.body)
                uSelf.isSuccess.value = false
            }
        }
    }
    
}
