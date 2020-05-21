//
//  AuthRouter.swift
//  CoBook
//
//  Created by protas on 3/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum AuthEndpoint: Endpoint {

    case forgotPassword(telephone: String)
    case refresh(refreshToken: String)
    case changeCredengials(parameters: APIRequestParameters.Auth.Credentials)
    case logout

    // MARK: - Auth token usage
    
    var useAuthirizationToken: Bool {
        switch self {
        case .forgotPassword, .refresh:
            return false
        case .changeCredengials, .logout:
            return true
        }
    }

    // MARK: - HTTPMethod

    var method: HTTPMethod {
        switch self {
        case .forgotPassword:
            return .post
        case .refresh:
            return .post
        case .changeCredengials:
            return .put
        case .logout:
            return .post
        }
    }

    // MARK: - Path

    var path: String {
        switch self {
        case .forgotPassword:
            return "/forgot_password"
        case .refresh:
            return "/refresh"
        case .changeCredengials:
            return "/credentials"
        case .logout:
            return "/logout"
        }
    }

    // MARK: - Parameters

    var bodyParameters: Parameters? {
        switch self {

        case let .forgotPassword(telephone):
            return [
                APIConstants.ParameterKey.telephone: telephone,
            ]

        case let .refresh(token):
            return [
                APIConstants.ParameterKey.refreshToken: token,
            ]

        case .changeCredengials(let parameters):
            return parameters.dictionary

        default: return nil

        }

    }


}
