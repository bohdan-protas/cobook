//
//  AuthRequestInterceptor.swift
//  CoBook
//
//  Created by protas on 3/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

final class AuthRequestInterceptor: RequestInterceptor {

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            // The request did not fail due to a 403 Unauthorized response.
            // Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }

        switch response.statusCode {
        case 401:
            let myError = NSError.init(domain: "", code: 401, userInfo: nil)
            completion(.doNotRetryWithError(myError))
        case 403:
            APIClient.default.refreshTokenRequest(refreshToken: AppStorage.Auth.refreshToken ?? "") { (result) in
                switch result {
                case let .success(response):
                    if response.status == .ok {
                        AppStorage.Auth.accessToken = response.data?.accessToken
                        completion(.retry)
                    } else {
                        AppStorage.Auth.deleteAllData()
                        let myError = NSError.init(domain: "", code: 401, userInfo: nil)
                        completion(.doNotRetryWithError(myError))
                    }
                case let .failure(error):
                    AppStorage.Auth.deleteAllData()
                    completion(.doNotRetryWithError(error))
                }
            }
        default:
            return completion(.doNotRetryWithError(error))
        }



    }

}
