//
//  CardStatisticInfoApiModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CardStatisticInfoApiModel: Decodable {
    var id: Int?
    var cardCreator: CardCreatorApiModel?
    var avatar: FileDataApiModel?
    var practiceType: PracticeTypeApiModel?
    var company: CompanyApiModel?
    var contactTelephone: TelephoneApiModel?
    var cardType: CardType?
    var savedCount: String?
    var sharingCount: Int?
    var cardViewsCount: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case cardCreator = "created_by"
        case avatar
        case practiceType = "practice_type"
        case company
        case contactTelephone = "contact_telephone"
        case cardType = "type"
        case savedCount = "saved"
        case sharingCount = "sharing_count"
        case cardViewsCount = "card_views"
    }
}
