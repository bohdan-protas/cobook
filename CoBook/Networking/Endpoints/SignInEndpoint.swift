//
//  SignInRouter.swift
//  CoBook
//
//  Created by protas on 3/1/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum SignInEndpoint: Endpoint {

    /**
     Login route

     - parameters:
        - login: The users telephone
        - password: The users password str
     */
    case login(login: String, password: String)

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
        case .login:
            return "/sign_in"
        }
    }

    // MARK: - Parameters
    var bodyParameters: Parameters? {
        switch self {

        case let .login(login, password):
            return [
                APIConstants.ParameterKey.login: login,
                APIConstants.ParameterKey.password: password,
            ]


        }
    }


}
