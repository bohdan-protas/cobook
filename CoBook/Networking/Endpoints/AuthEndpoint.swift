//
//  AuthRouter.swift
//  CoBook
//
//  Created by protas on 3/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum AuthEndpoint: Endpoint {

    /**
     Request new credentials via login router

     - parameters:
        - telephone: The users telephone
     */
    case forgotPassword(telephone: String)

    /**
     Request access token via refresh token router

     - parameters:
        - refreshToken: current users refresh token
     */
    case refresh(refreshToken: String)

    // MARK: - Auth token usage
    var useAuthirizationToken: Bool {
        return false
    }

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        return .post
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .forgotPassword:
            return "/forgot_password"
        case .refresh:
            return "/refresh"
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {

        case let .forgotPassword(telephone):
            return [
                APIConstants.ParameterKey.telephone: telephone,
            ]

        case let .refresh(token):
            return [
                APIConstants.ParameterKey.refreshToken: token,
            ]
        }

    }


}
