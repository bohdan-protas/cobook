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
    case getCardsList(type: String?, interestsIds: [Int]? = nil, practiseTypeIds: [Int]? = nil, search: String? = nil, limit: UInt? = nil, offset: UInt? = nil)

    case getCardLocationsInRegion(topLeftRectCoordinate: CoordinateApiModel, bottomRightRectCoordinate: CoordinateApiModel)
    case getSavedCardsLocationsInRegion(topLeftRectCoordinate: CoordinateApiModel, bottomRightRectCoordinate: CoordinateApiModel)

    case addCardToFavourite(cardID: Int, tagID: Int? = nil)
    case deleteCardFromFavourite(cardID: Int)
    case getSavedCardList(tagID: Int?, type: String?, limit: Int?, offset: Int?)
    case getFolders(limit: Int?, offset: Int?)

    case createFolder(title: String)
    case deleteFolder(id: Int)
    case updateFolder(id: Int, title: String)
    
    case statistics

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
        case .addCardToFavourite:
            return .post
        case .deleteCardFromFavourite:
            return .delete
        case .getSavedCardList:
            return .get
        case .getFolders:
            return .get
        case .createFolder:
            return .post
        case .deleteFolder:
            return .delete
        case .updateFolder:
            return .put
        case .getSavedCardsLocationsInRegion:
            return .post
        case .statistics:
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
        case .addCardToFavourite, .deleteCardFromFavourite, .getSavedCardList:
            return "/cards/favourites"
        case .getFolders, .createFolder, .deleteFolder, .updateFolder:
            return "/cards/favourites/tags"
        case .getSavedCardsLocationsInRegion:
            return "/cards/favourites/area-list"
        case .statistics:
            return "/cards/statistics"
        }
    }

    var urlParameters: [String : String]? {
        switch self {

        case .getSavedCardList(let tagID, let type, let limit, let offset):
            var params: [String : String] = [:]
            if let tagID = tagID {
                params["tag_id"] = "\(tagID)"
            }
            if let type = type {
                params["type"] = type
            }
            if let limit = limit {
                params["limit"] = "\(limit)"
            }
            if let offset = offset {
                params["offset"] = "\(offset)"
            }
            return params

        case .getFolders(let limit, let offset):
            var params: [String : String] = [:]
            if let limit = limit {
                params["limit"] = "\(limit)"
            }
            if let offset = offset {
                params["offset"] = "\(offset)"
            }
            return params

        default:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {

        case .getCardInfo(let id):
            return [
                Constants.API.ParameterKey.id: id,
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

        case .getSavedCardsLocationsInRegion(let topLeftRectCoordinate, let bottomRightRectCoordinate):
            return [
                "top_left": topLeftRectCoordinate.dictionary ?? [],
                "bottom_right": bottomRightRectCoordinate.dictionary ?? []
            ]

        case .addCardToFavourite(let cardID, let tagID):
            var params: Parameters = [:]
            params["card_id"] = cardID
            params["tag_id"] = tagID
            return params

        case .deleteCardFromFavourite(let cardID):
            return ["card_id": cardID]

        case .createFolder(let title):
            return ["title": title]

        case .deleteFolder(let id):
            return ["id": id]

        case .updateFolder(let id, let title):
            return ["id": id, "title": title]
            
        case .statistics:
            return ["type": ""]
            
        default: return nil
        }
    }


}


