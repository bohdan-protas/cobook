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
    case update(parameters: UpdateServiceApiModel)
    case getList(cardID: Int, limit: Int?, offset: Int?)
    case getDetails(serviceID: Int)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .create, .getList:
            return .post
        case .getDetails:
            return .get
        case .update:
            return .put
        }
    }

    var path: String {
        switch self {

        case .create, .update:
            return "/services"

        case .getList:
            return "/services/list"

        case .getDetails(let serviceID):
            return "/services/\(serviceID)"
        }
    }

    var bodyParameters: Parameters? {
        switch self {

        case .create(let parameters):
            return parameters.dictionary

        case .update(let parameters):
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

        case .getDetails:
            return nil
        }
    }


}
