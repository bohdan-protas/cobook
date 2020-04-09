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
                let signInViewController: SignInViewController = UIStoryboard.auth.initiateViewControllerFromType()
                if let topController = UIApplication.topViewController() {
                    topController.present(signInViewController, animated: true, completion: {
                        (topController.presentedViewController as? AlertDisplayableView)?.errorAlert(message: "Please, login before continue")
                    })
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
                        case let .failure(error):
                            DispatchQueue.main.async {
                                AppStorage.Auth.deleteAllData()
                                let signInViewController: SignInViewController = UIStoryboard.auth.initiateViewControllerFromType()
                                if let topController = UIApplication.topViewController() {
                                    topController.present(signInViewController, animated: true, completion: {
                                        (topController.presentedViewController as? AlertDisplayableView)?.errorAlert(message: error.localizedDescription)
                                    })
                                }
                                completion(.doNotRetry)
                            }

                        }
                    }
                } else {
                    AppStorage.Auth.deleteAllData()
                    let signInViewController: SignInViewController = UIStoryboard.auth.initiateViewControllerFromType()
                    if let topController = UIApplication.topViewController() {
                        topController.present(signInViewController, animated: true, completion: {
                            (topController.presentedViewController as? AlertDisplayableView)?.errorAlert(message: "Please, login before continue")
                        })
                    }
                    completion(.doNotRetry)
                }
            }

        default:
            return completion(.doNotRetryWithError(error))
        }



    }

}


