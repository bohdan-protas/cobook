//
//  ServicesEndpoint.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ServicesEndpoint: Endpoint {

    case create(parameters: CreateServiceApiModel)
    case getList(cardID: Int, limit: Int?, offset: Int?)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .create, .getList:
            return .post
        }
    }

    var path: String {
        switch self {
        case .create:
            return "/services"
        case .getList:
            return "/services/list"
        }
    }

    var parameters: Parameters? {
        switch self {

        case .create(let parameters):
            return parameters.dictionary

        case .getList(let cardID, let limit, let offset):
            var params: Parameters = [:]

            params["card_id"] = cardID

            if let limit = limit {
                params["limit"] = limit
            }
            if let offset = offset {
                params["offset"] = offset
            }

            return params
        }
    }


}
