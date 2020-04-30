//
//  ArticlesEndpoint.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ArticlesEndpoint: Endpoint {

    case getAlbums(cardID: Int?, limit: Int?, offset: Int?)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .getAlbums:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getAlbums:
            return "/articles/albums"
        }
    }

    var parameters: Parameters? {
        switch self {

        case .getAlbums(let cardID, let limit, let offset):
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
