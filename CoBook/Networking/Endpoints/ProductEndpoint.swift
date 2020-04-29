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

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .update:
            return .put
        }
    }

    var path: String {
        switch self {
        case .create, .update:
            return "/products"
        }
    }

    var parameters: Parameters? {
        switch self {

        case .create(let parameters):
            return parameters.dictionary

        case .update(let parameters):
            return parameters.dictionary
        }
    }


}
