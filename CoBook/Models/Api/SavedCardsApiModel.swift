//
//  SavedCardsApiModel.swift
//  CoBook
//
//  Created by protas on 5/14/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct SavedCardsApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case rows
    }

    var totalCount: Int?
    var rows: [CardItemApiModel]?
}

struct SavedPostsApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case rows
    }

    var totalCount: Int?
    var rows: [ArticlePreviewAPIModel]?

}
