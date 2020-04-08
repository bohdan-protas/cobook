//
//  CardsRouter.swift
//  CoBook
//
//  Created by protas on 3/16/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum CardsEndpoint: Endpoint {

    case updateBusinessCard(parameters: CreateBusinessCardParametersApiModel)
    case createBusinessCard(parameters: CreateBusinessCardParametersApiModel)
    case createPersonalCard(parameters: CreatePersonalCardParametersApiModel)
    case getCardInfo(id: Int)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .updateBusinessCard:
            return .put
        case .createBusinessCard:
            return .post
        case .createPersonalCard:
            return .post
        case .getCardInfo:
            return .post

        }
    }

    var path: String {
        switch self {
        case .createPersonalCard:
            return "/cards/personal"
        case .getCardInfo:
            return "/cards/info"
        case .createBusinessCard:
            return "/cards/business"
        case .updateBusinessCard:
            return "/cards/business"
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

        case .updateBusinessCard(let parameters):
            return parameters.dictionary
            
        }
    }


}


