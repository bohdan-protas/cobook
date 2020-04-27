//
//  CreatePersonalCardParameters.swift
//  CoBook
//
//  Created by protas on 4/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CreatePersonalCardParametersApiModel: Encodable {
    var avatarId: String?
    var cityPlaceId: String?
    var regionPlaceId: String?
    var position: String?
    var description: String?
    var practiceTypeId: Int?
    var interestsIds: [Int]?
    var contactTelephone: String?
    var contactEmail: String?
    var socialNetworks: [SocialNetworkApiModel]?

    init(model: CreatePersonalCard.DetailsModel) {
        self.avatarId = model.avatarImage?.id
        self.cityPlaceId = model.city?.googlePlaceId
        self.regionPlaceId = model.region?.googlePlaceId
        self.position = model.position
        self.description = model.description?.trimmingCharacters(in: CharacterSet.whitespaces)
        self.practiceTypeId = model.practiseType?.id
        self.interestsIds = model.interests
            .filter { $0.isSelected }
            .compactMap { $0.id }
        self.contactTelephone = model.contactTelephone?.trimmingCharacters(in: CharacterSet.whitespaces)
        self.contactEmail = model.contactEmail?.trimmingCharacters(in: CharacterSet.whitespaces)
        self.socialNetworks = model.socials
            .compactMap {
                switch $0 {
                case .view(let model): return SocialNetworkApiModel(title: model.title, link: model.url?.absoluteString)
                default: return nil
                }
            }
    }

    enum CodingKeys: String, CodingKey {
        case avatarId  = "avatar_id"
        case cityPlaceId = "city_place_id"
        case regionPlaceId = "region_place_id"
        case position
        case description
        case practiceTypeId = "practise_type_id"
        case interestsIds = "interests_ids"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case socialNetworks = "social_networks"
    }
}
