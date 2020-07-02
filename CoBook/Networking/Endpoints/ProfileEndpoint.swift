//
//  ProfileEndpoint.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ProfileEndpoint: EndpointConfigurable {

    case details
    case update(parameters: APIRequestParameters.Profile.Update)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .details:
            return .get
        case .update:
            return .put
        }
    }

    var path: String {
        switch self {
        case .details, .update:
            return "/profile"
        }
    }

    var bodyParameters: Parameters? {
        switch self {

        case .update(let parameters):
            return parameters.dictionary

        default:
            return nil
        }
    }


}
