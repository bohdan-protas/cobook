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

    ///
    case getCardsList(type: String?, interestsIds: [Int]? = nil, practiseTypeIds: [Int]? = nil, search: String? = nil, limit: Int? = nil, offset: Int? = nil)
    case getCardLocationsInRegion(topLeftRectCoordinate: CoordinateApiModel, bottomRightRectCoordinate: CoordinateApiModel)

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
        case .getCardsList:
            return .post
        case .getCardLocationsInRegion:
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
        case .getCardsList:
            return "/cards/list"
        case .getCardLocationsInRegion:
            return "/cards/area-list"
        }
    }

    var bodyParameters: Parameters? {
        switch self {

        case .getCardInfo(let id):
            return [
                APIConstants.ParameterKey.id: id,
            ]

        case .createPersonalCard(let parameters):
            return parameters.dictionary

        case .createBusinessCard(let parameters):
            return parameters.dictionary

        case .updateBusinessCard(let parameters):
            return parameters.dictionary

        case .getCardsList(let type, let interestsIds, let practiseTypeIds, let search, let limit, let offset):
            var params: Parameters = [:]
            if let interestsIds = interestsIds {
                params["interests_ids"] = interestsIds
            }

            if let practiseTypeIds = practiseTypeIds {
                params["practise_type_ids"] = practiseTypeIds
            }

            if let limit = limit {
                params["limit"] = limit
            }

            if let offset = offset {
                params["offset"] = offset
            }

            if let search = search {
                params["search"] = search
            }

            if let type = type {
                params["type"] = type
            }
            return params

        case .getCardLocationsInRegion(let topLeftRectCoordinate, let bottomRightRectCoordinate):
            return [
                "top_left": topLeftRectCoordinate.dictionary ?? [],
                "bottom_right": bottomRightRectCoordinate.dictionary ?? []
            ]


        }
    }


}


