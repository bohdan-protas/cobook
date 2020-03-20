//
//  SignUpRouter.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum SignUpEndpoint: Endpoint {

    /// Initialize registration session
    case initialize(email: String, telephone: String, firstName: String, lastName: String)

    /// Verify telephone via sms
    case verify(smsCode: Int, accessToken: String)

    ///Finish registration session
    case finish(accessToken: String, password: String)

    ///Request resend sms
    case resend(accessToken: String)

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
        case .initialize:
            return "/sign_up/init"
        case .verify:
            return "/sign_up/verify"
        case .finish:
            return "/sign_up/finish"
        case .resend:
            return "/sign_up/resend"
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {

        case let .initialize(email, telephone, firstName, lastName):
            return [
                APIConstants.ParameterKey.email: email,
                APIConstants.ParameterKey.telephone: telephone,
                APIConstants.ParameterKey.firstName: firstName,
                APIConstants.ParameterKey.lastName: lastName,
            ]

        case .verify(let smsCode, let accessToken):
            return [
                APIConstants.ParameterKey.code: smsCode,
                APIConstants.ParameterKey.token: accessToken
            ]

        case .finish(let accessToken, let password):
            return [
                APIConstants.ParameterKey.token: accessToken,
                APIConstants.ParameterKey.password: password
            ]

        case .resend(let accessToken):
            return [
                APIConstants.ParameterKey.token: accessToken,
            ]


        }
    }


}
