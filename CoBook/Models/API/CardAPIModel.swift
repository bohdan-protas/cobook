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

    struct SocialNetwork: Codable {
        var title: String?
        var link: String?
    }

    struct Place: Decodable {
        var id: Int?
        var placeId: String?
        var name: String?

        enum CodingKeys: String, CodingKey {
            case id
            case name
        }

        init(placeId: String? = nil, name: String? = nil) {
            self.placeId = placeId
            self.name = name
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decodeIfPresent(Int.self, forKey: .id)
            name = try container.decodeIfPresent(String.self, forKey: .name)
        }
    }

    struct CardCreator: Decodable {
        var id: String
        var firstName: String?
        var lastName: String?

        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
        }
    }

    struct Company: Decodable {
        var id: Int
        var name: String?
    }

    struct ContactTelephone: Decodable {
        var id: Int
        var number: String?
    }

    struct ContactEmail: Decodable {
        var id: Int
        var address: String?
    }

    enum CardType: String, Decodable {
        case personal
    }


}

// MARK: - PersonalCardParameters
extension CardAPIModel {

    struct PersonalCardParameters: Encodable {
        var avatarId: String?
        var city: Place = Place()
        var region: Place = Place()
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
            try container.encodeIfPresent(avatarId, forKey: .avatarId)
            try container.encodeIfPresent(city.placeId, forKey: .cityPlaceId)
            try container.encodeIfPresent(region.placeId, forKey: .regionPlaceId)
            try container.encodeIfPresent(position, forKey: .position)
            try container.encodeIfPresent(description, forKey: .description)
            try container.encodeIfPresent(practiseType.id, forKey: .practiseTypeId)
            try container.encodeIfPresent(interests.map { $0.id }, forKey: .interestsIds)
            try container.encodeIfPresent(contactTelephone, forKey: .contactTelephone)
            try container.encodeIfPresent(contactEmail, forKey: .contactEmail)
            try container.encodeIfPresent(socialNetworks, forKey: .socialNetworks)
        }
    }


}

// MARK: - PersonalCardAPIResponseData
extension CardAPIModel {

    struct CardDetailsAPIResponseData: Decodable {

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case cardCreator = "created_by"
            case avatar
            case practiceType = "practice_type"
            case position
            case city
            case region
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
        var cardCreator: CardCreator?
        var avatar: FileAPIResponseData?
        var practiceType: PracticeType?
        var position: String?
        var city: Place?
        var region: Place?
        var description: String?
        var contactTelephone: ContactTelephone?
        var contactEmail: ContactEmail?
        var socialNetworks: [SocialNetwork]?
        var createdAt: String?
        var updatedAt: String?
        var interests: [Interest]?
    }


}
