//
//  CreateAlbumApiModel.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CreateAlbumApiModel: Encodable {
    var cardID: Int
    var avatarID: String?
    var title: String?

    enum CodingKeys: String, CodingKey {
        case title
        case cardID = "card_id"
        case avatarID = "avatar_id"
    }
}

struct UpdateAlbumApiModel: Encodable {
    var albumID: Int?
    var title: String?
    var avatarID: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "id"
        case title
        case avatarID = "avatar_id"
    }
}
