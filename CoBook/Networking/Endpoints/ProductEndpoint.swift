//
//  ProductEndpoint.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ProductEndpoint: Endpoint {

    case create(parameters: CreateProductApiModel)
    case update(parameters: UpdateProductApiModel)
    case list(cardID: Int, limit: Int?, offset: Int?)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .update:
            return .put
        case .list:
            return .post
        }
    }

    var path: String {
        switch self {
        case .create, .update:
            return "/products"
        case .list:
            return "/products/list"
        }
    }

    var parameters: Parameters? {
        switch self {

        case .create(let parameters):
            return parameters.dictionary

        case .update(let parameters):
            return parameters.dictionary
            
        case .list(let cardID, let limit, let offset):
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
