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
    var createdAt: Date?
    var photos: [FileDataApiModel]?
    var album: AlbumPreviewApiModel?
    var cardInfo: ArticleCardPreviewApiModel?
    var isSaved: Bool?
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
        case isSaved = "is_saved"
    }

}

struct ArticleCardPreviewApiModel: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case cardCreator = "created_by"
        case avatar
        case telephone = "contact_telephone"
        case email
        case practiceType = "practice_type"
        case company
        case isSaved = "is_saved"
    }

    var id: Int
    var type: CardType
    var cardCreator: CardCreatorApiModel?
    var avatar: FileDataApiModel?
    var telephone: TelephoneApiModel?
    var email: EmailApiModel?
    var practiceType: PracticeTypeApiModel?
    var company: CompanyApiModel?
    var isSaved: Bool?
}
