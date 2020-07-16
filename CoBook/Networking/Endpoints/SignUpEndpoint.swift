//
//  SignUpRouter.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum SignUpEndpoint: EndpointConfigurable {

    /// Initialize registration session
    case initialize(parameters: APIRequestParameters.SignUp.Initialize)

    /// Verify telephone via sms
    case verify(smsCode: Int, accessToken: String)

    ///Finish registration session
    case finish(accessToken: String, password: String, deviceID: String?)

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

    var bodyParameters: Parameters? {
        switch self {

        case .initialize(let parameters):
            return parameters.dictionary

        case .verify(let smsCode, let accessToken):
            return [
                Constants.API.ParameterKey.code: smsCode,
                Constants.API.ParameterKey.token: accessToken
            ]

        case .finish(let accessToken, let password, let deviceID):
            return [
                Constants.API.ParameterKey.token: accessToken,
                Constants.API.ParameterKey.password: password,
                Constants.API.ParameterKey.deviceID: deviceID ?? ""
            ]

        case .resend(let accessToken):
            return [
                Constants.API.ParameterKey.token: accessToken,
            ]
        }
    }


}
