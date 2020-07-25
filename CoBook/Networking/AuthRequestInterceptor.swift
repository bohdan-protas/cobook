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

        // Do not retry device token request
        if request.request?.url?.absoluteString == AuthEndpoint.updateDeviceToken(fcmToken: "").urlRequest?.url?.absoluteString {
            completion(.doNotRetry)
            return
        }
        
        switch response.statusCode {
        case 401:
            if let refreshToken = AppStorage.Auth.refreshToken, !refreshToken.isEmpty {
                AppStorage.Auth.accessToken = nil
                APIClient.default.refreshTokenRequest(refreshToken: refreshToken) { (result) in
                    switch result {
                    case let .success(response):
                        AppStorage.Auth.accessToken = response?.accessToken
                        completion(.retry)
                    case .failure:
                        completion(.doNotRetry)
                        DispatchQueue.main.async {
                            self.showSignInController()
                        }
                    }
                }
            } else {
                completion(.doNotRetry)
                DispatchQueue.main.async {
                    self.showSignInController()
                }
            }


        default:
            return completion(.doNotRetryWithError(error))
        }
    }

    func showSignInController() {
        AppStorage.Auth.deleteAllData()
        let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
        if let topController = UIApplication.topViewController(), !(topController is SignInViewController) {
            topController.present(signInNavigationController, animated: true, completion: nil)
        }
    }

}


