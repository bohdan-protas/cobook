//
//  PersonalCardAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CardAPIModel {

    struct Interest: Decodable {
        var id: Int?
        var title: String?
    }

    struct PracticeType: Decodable {
        var id: Int?
        var title: String?
    }

    struct SocialNetwork: Encodable {
        var title: String?
        var link: String?
    }

    struct Region: Codable {
        var id: Int?
        var placeId: String?
        var name: String?
    }

    struct City: Codable {
        var id: Int?
        var placeId: String?
        var name: String?
    }

    struct PersonalCardParameters: Encodable {
        var avatarId: String?
        var city: City = City()
        var region: Region = Region()
        var position: String?
        var description: String?
        var practiseType: PracticeType = PracticeType()
        var contactTelephone: String?
        var contactEmail: String?
        var socialNetworks: [SocialNetwork] = []

        var interests:  [CreatePersonalCard.Interest] = []
        var practices:  [CreatePersonalCard.Practice] = []
        var socialList: [Social.ListItem] = []

        enum CodingKeys: String, CodingKey {
            case avatarId = "avatar_id"
            case cityPlaceId = "city_place_id"
            case regionPlaceId = "region_place_id"
            case position
            case description
            case practiseTypeId = "practise_type_id"
            case interestsIds = "interests_ids"
            case contactTelephone = "contact_telephone"
            case contactEmail = "contact_email"
            case socialNetworks = "social_networks"
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            /// avatarId
            try container.encodeIfPresent(avatarId, forKey: .avatarId)

            /// cityPlaceId
            try container.encodeIfPresent(city.placeId, forKey: .cityPlaceId)

            /// regionPlaceId
            try container.encodeIfPresent(region.placeId, forKey: .regionPlaceId)

            /// position
            try container.encodeIfPresent(position, forKey: .position)

            /// description
            try container.encodeIfPresent(description, forKey: .description)

            /// practiseTypeId
            try container.encodeIfPresent(practiseType.id, forKey: .practiseTypeId)

            /// interestsIds
            let interestsIds = interests.map { $0.id }
            try container.encodeIfPresent(interestsIds, forKey: .interestsIds)

            /// contactTelephone
            try container.encodeIfPresent(contactTelephone, forKey: .contactTelephone)

            /// contactEmail
            try container.encodeIfPresent(contactEmail, forKey: .contactEmail)

            /// socialNetworks
            try container.encodeIfPresent(socialNetworks, forKey: .socialNetworks)

        }
    }


}
