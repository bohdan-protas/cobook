//
//  ArticlesEndpoint.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ArticlesEndpoint: Endpoint {

    case getAlbums
    case createAlbum(parameters: CreateAlbumApiModel)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .getAlbums:
            return .get
        case .createAlbum:
            return .post
        }
    }

    var path: String {
        switch self {
        case .getAlbums:
            return "/articles/albums"
        case .createAlbum:
            return "articles/albums"
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getAlbums:
            return nil

        case .createAlbum(let parameters):
            return parameters.dictionary

        }
    }


}
