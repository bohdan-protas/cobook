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
            return completion(.doNotRetryWithError(error))
        }

        switch response.statusCode {
        case 401:
            DispatchQueue.main.async {
                AppStorage.Auth.deleteAllData()
                let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                if let topController = UIApplication.topViewController() {
                    topController.present(signInNavigationController, animated: true, completion: nil)
                }
                completion(.doNotRetry)
            }

        case 403:
            DispatchQueue.main.async {
                if let refreshToken = AppStorage.Auth.refreshToken, !refreshToken.isEmpty {
                    AppStorage.Auth.accessToken = nil
                    APIClient.default.refreshTokenRequest(refreshToken: refreshToken) { (result) in
                        switch result {

                        case let .success(response):
                            AppStorage.Auth.accessToken = response?.accessToken
                            completion(.retry)

                        case .failure:
                            DispatchQueue.main.async {
                                AppStorage.Auth.deleteAllData()
                                let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                                if let topController = UIApplication.topViewController() {
                                    topController.present(signInNavigationController, animated: true, completion: nil)
                                }
                                completion(.doNotRetry)
                            }

                        }
                    }
                } else {
                    AppStorage.Auth.deleteAllData()
                    let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                    if let topController = UIApplication.topViewController() {
                        topController.present(signInNavigationController, animated: true, completion: nil)
                    }
                    completion(.doNotRetry)
                }
            }

        default:
            return completion(.doNotRetryWithError(error))
        }



    }

}


