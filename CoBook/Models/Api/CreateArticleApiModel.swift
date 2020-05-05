//
//  CreateArticleApiModel.swift
//  CoBook
//
//  Created by protas on 5/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


struct CreateArticleApiModel: Encodable {
    var cardID: Int
    var albumID: Int?
    var title: String?
    var body: String?
    var photos: [String] = []

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case title
        case body
        case cardID = "card_id"
        case photos = "attachments"
    }

}
