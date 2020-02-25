//
//  SignUpRouter.swift
//  CoBook
//
//  Created by protas on 2/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation
import Alamofire

enum SignUpRouter: APIConfigurable {

    /// Initialize registration session
    case initializeRequest(email: String, telephone: String, firstName: String, lastName: String)


    // MARK: - Auth token usage
    var useAuthirizationToken: Bool {
        return false
    }

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .initializeRequest:
            return .post
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .initializeRequest:
            return "/sign_up/init"
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case let .initializeRequest(email, telephone, firstName, lastName):
            return [
                APIConstants.ParameterKey.email: email,
                APIConstants.ParameterKey.telephone: telephone,
                APIConstants.ParameterKey.firstName: firstName,
                APIConstants.ParameterKey.lastName: lastName,
            ]
        }
    }


}
