//
//  ArticlesEndpoint.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Alamofire

enum ArticlesEndpoint: Endpoint {

    case getAlbums(cardID: Int?)
    case createAlbum(parameters: CreateAlbumApiModel)
    case updateAlbum(parameters: UpdateAlbumApiModel)

    case createArticle(parameters: CreateArticleApiModel)
    case getArticleDetails(id: Int)
    case getArticlesList(albumID: Int)

    var useAuthirizationToken: Bool {
        return true
    }

    var method: HTTPMethod {
        switch self {
        case .getAlbums:
            return .get
        case .createAlbum:
            return .post
        case .createArticle:
            return .post
        case .updateAlbum:
            return .put
        case .getArticleDetails:
            return .post
        case .getArticlesList:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getAlbums:
            return "/articles/albums"
        case .createAlbum:
            return "/articles/albums"
        case .createArticle:
            return "/articles"
        case .updateAlbum:
            return "/articles/albums"
        case .getArticleDetails:
            return "/articles/info"
        case .getArticlesList:
            return "/articles"
        }
    }

    var urlParameters: [String : String]? {
        switch self {
        case .getAlbums(let cardID):
            if let cardID = cardID {
                return ["card_id": String(cardID)]
            }
            return nil
        case .getArticlesList(let albumID):
            return ["album_id": String(albumID)]
        default:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .createAlbum(let parameters):
            return parameters.dictionary
        case .createArticle(let parameters):
            return parameters.dictionary
        case .updateAlbum(let parameters):
            return parameters.dictionary
        case .getArticleDetails(let id):
            return ["id": id]
        default:
            return nil
        }
    }


}
