//
//  CardsRouter.swift
//  CoBook
//
//  Created by protas on 3/16/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum CardsEndpoint: Endpoint {

    case createPersonalCard(parameters: CreatePersonalCardParametersApiModel)
    case getCardInfo(id: Int)

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
        }
    }


}


