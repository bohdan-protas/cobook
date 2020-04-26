//
//  ServicesEndpoint.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ServicesEndpoint: Endpoint {

    case createService(parameters: CreateServiceApiModel)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .createService:
            return .post
        }
    }

    var path: String {
        switch self {
        case .createService:
            return "/services"
        }
    }

    var parameters: Parameters? {
        switch self {

        case .createService(let parameters):
            return parameters.dictionary

        }
    }


}
