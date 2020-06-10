//
//  CardItemApiModel.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CardItemApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case cardCreator = "created_by"
        case company
        case avatar
        case practiceType = "practice_type"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case isSaved = "is_saved"
    }

    var id: Int
    var type: CardType
    var cardCreator: CardCreatorApiModel?
    var company: CompanyApiModel?
    var avatar: FileDataApiModel?
    var practiceType: PracticeTypeApiModel?
    var contactTelephone: TelephoneApiModel?
    var contactEmail: EmailApiModel?
    var isSaved: Bool?
}
