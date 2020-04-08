//
//  CardsRouter.swift
//  CoBook
//
//  Created by protas on 3/16/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum CardsEndpoint: Endpoint {

    case createBusinessCard(parameters: CreateBusinessCardParametersApiModel)
    case createPersonalCard(parameters: CreatePersonalCardParametersApiModel)
    case getCardInfo(id: Int)
    case getCardsList(type: String?, limit: Int?, offset: Int?)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .createPersonalCard:
            return "/cards/personal"
        case .getCardInfo:
            return "/cards/info"
        case .createBusinessCard:
            return "/cards/business"
        case .getCardsList:
            return "/cards/list"
        }
    }

    var parameters: Parameters? {
        switch self {

        case .createPersonalCard(let parameters):
            return parameters.dictionary

        case .getCardInfo(let id):
            return [
                APIConstants.ParameterKey.id: id,
            ]

        case .createBusinessCard(let parameters):
            return parameters.dictionary

        case .getCardsList(let type, let limit, let offset):
            var params: Parameters = [
                "limit": limit ?? 15,
                "offset": offset ?? 0
            ]
            if let type = type {
                params["type"] = type
            }
            return params


        }
    }


}


