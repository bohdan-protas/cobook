//
//  PersonalCardAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CardDetailsApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case cardCreator = "created_by"
        case company
        case companyWebSite = "company_web_site"
        case avatar
        case background
        case practiceType = "practice_type"
        case position
        case city
        case region
        case address
        case schedule
        case description
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case socialNetworks = "social_networks"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case interests
    }

    var id: Int
    var type: CardType?
    var cardCreator: CardCreatorApiModel?
    var company: CompanyApiModel
    var companyWebSite: String?
    var avatar: FileDataApiModel?
    var background: FileDataApiModel?
    var practiceType: PracticeTypeApiModel?
    var position: String?
    var city: PlaceApiModel?
    var region: PlaceApiModel?
    var address: PlaceApiModel?
    var schedule: String?
    var description: String?
    var contactTelephone: TelephoneApiModel?
    var contactEmail: EmailApiModel?
    var socialNetworks: [SocialNetworkApiModel]?
    var createdAt: String?
    var updatedAt: String?
    var interests: [InterestApiModel]?
}
