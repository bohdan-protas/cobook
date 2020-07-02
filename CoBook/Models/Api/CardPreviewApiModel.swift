//
//  CardPreviewApiModel.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - CardPreviewApiModel
struct CardPreviewApiModel: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case cardCreator = "created_by"
        case avatar
        case telephone
        case email
        case practiceType = "practice_type"
        case company
        case isSaved = "is_saved"
        case subscriptionEndDate = "subscription_end_date"
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
    var subscriptionEndDate: Date?
}

