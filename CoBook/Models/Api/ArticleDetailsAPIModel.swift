//
//  ArticleDetailsAPIModel.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct ArticleDetailsAPIModel: Decodable {
    var articleID: Int
    var userID: String
    var title: String?
    var body: String?
    var createdAt: String?
    var photos: [FileDataApiModel]?
    var album: AlbumPreviewApiModel?
    var cardInfo: CardPreviewApiModel?
    var viewsCount: String?

    enum CodingKeys: String, CodingKey {
        case articleID = "id"
        case userID = "user_id"
        case title
        case body
        case createdAt = "created_at"
        case photos = "attachments"
        case album
        case cardInfo = "card_info"
        case viewsCount = "views"
    }
}
