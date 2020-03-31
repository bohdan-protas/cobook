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
            case placeId = "place_id"
        }

        init(id: Int? = nil, placeId: String? = nil, name: String? = nil) {
            self.id = id
            self.placeId = placeId
            self.name = name

            if placeId == nil {
                self.name = nil
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decodeIfPresent(Int.self, forKey: .id)
            placeId = try container.decodeIfPresent(String.self, forKey: .placeId)
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

// MARK: - Create & Update parameters
extension CardAPIModel {

//    struct BusinessCardParameters {
//        var avatarId: String?
//        var avatarUrl: String?
//        var bgImageId: String?
//        var bgImageUrl: String?
//        var city: Place = Place()
//        var region: Place = Place()
//        var companyName: String?
//        var companyWebSite: String?
//        var addressPlaceId: String?
//        var schedule: String?
//        var practiseType: PracticeType = PracticeType()
//        var interests:  [Card.InterestItem] = []
//        var contactTelephone: String?
//        var contactEmail: String?
//        var socialNetworks: [Social.ListItem] = []
//        var employeeIds: [Int] = []
//        var practices:  [Card.PracticeItem] = []
//
//        enum CodingKeys: String, CodingKey {
//            case avatarId = "avatar_id"
//            case bgImageId = "background_id"
//            case cityPlaceId = "city_place_id"
//            case regionPlaceId = "region_place_id"
//            case companyName = "company_name"
//            case companyWebSite = "company_web_site"
//            case addressPlaceId  = "address_place_id"
//            case schedule = "schedule"
//            case practiseTypeId = "practise_type_id"
//            case interestsIds = "interests_ids"
//            case contactTelephone = "contact_telephone"
//            case contactEmail = "contact_email"
//            case socialNetworks = "social_networks"
//            case employeeIds = "employee_ids"
//        }
//
//        init() {
//        }
//
//        init(with model: CardDetailsAPIResponseData) {
//            self.avatarId = model.avatar?.id
//            self.avatarUrl = model.avatar?.sourceUrl
//            self.city = Place(id: model.city?.id, placeId: model.city?.placeId, name: model.city?.name)
//            self.region = Place(id: model.region?.id, placeId: model.region?.placeId, name: model.region?.name)
//            self.practiseType = PracticeType(id: model.practiceType?.id, title: model.practiceType?.title)
//            self.interests = (model.interests ?? []).compactMap { Card.InterestItem(id: $0.id, title: $0.title, isSelected: true) }
//            self.contactTelephone = model.contactTelephone?.number
//            self.contactEmail = model.contactEmail?.address
//            self.socialNetworks = (model.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
//        }
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encodeIfPresent(avatarId, forKey: .avatarId)
//            try container.encodeIfPresent(bgImageId, forKey: .bgImageId)
//            try container.encodeIfPresent(city.placeId, forKey: .cityPlaceId)
//            try container.encodeIfPresent(region.placeId, forKey: .regionPlaceId)
//            try container.encodeIfPresent(companyName, forKey: .companyName)
//            try container.encodeIfPresent(companyWebSite, forKey: .companyWebSite)
//            try container.encodeIfPresent(addressPlaceId, forKey: .addressPlaceId)
//            try container.encodeIfPresent(schedule, forKey: .schedule)
//            try container.encodeIfPresent(practiseType.id, forKey: .practiseTypeId)
//            try container.encodeIfPresent(interests.filter { $0.isSelected }.map { $0.id }, forKey: .interestsIds)
//            try container.encodeIfPresent(contactTelephone, forKey: .contactTelephone)
//            try container.encodeIfPresent(contactEmail, forKey: .contactEmail)
//
//            let list: [SocialNetwork] = socialNetworks.compactMap {
//                switch $0 {
//                case .view(let model):
//                    return SocialNetwork(title: model.title, link: model.url?.absoluteString)
//                default:
//                    return nil
//                }
//
//            }
//            try container.encodeIfPresent(list, forKey: .socialNetworks)
//            try container.encodeIfPresent(employeeIds, forKey: .employeeIds)
//        }
//    }

    struct PersonalCardParameters: Encodable {
        var avatarId: String?
        var avatarUrl: String?
        var city: Place = Place()
        var region: Place = Place()
        var position: String?
        var description: String?
        var practiseType: PracticeType = PracticeType()
        var interests:  [CreateCard.InterestItem] = []
        var contactTelephone: String?
        var contactEmail: String?
        var practices:  [CreateCard.PracticeItem] = []
        var socialNetworks: [Social.ListItem] = []

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

        init() {
        }

        init(with model: CardDetailsAPIResponseData) {
            self.avatarId = model.avatar?.id
            self.avatarUrl = model.avatar?.sourceUrl
            self.city = Place(id: model.city?.id, placeId: model.city?.placeId, name: model.city?.name)
            self.region = Place(id: model.region?.id, placeId: model.region?.placeId, name: model.region?.name)
            self.position = model.position
            self.description = model.description
            self.practiseType = PracticeType(id: model.practiceType?.id, title: model.practiceType?.title)
            self.interests = (model.interests ?? []).compactMap { CreateCard.InterestItem(id: $0.id, title: $0.title, isSelected: true) }
            self.contactTelephone = model.contactTelephone?.number
            self.contactEmail = model.contactEmail?.address
            self.socialNetworks = (model.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(avatarId, forKey: .avatarId)
            try container.encodeIfPresent(city.placeId, forKey: .cityPlaceId)
            try container.encodeIfPresent(region.placeId, forKey: .regionPlaceId)
            try container.encodeIfPresent(position, forKey: .position)
            try container.encodeIfPresent(description, forKey: .description)
            try container.encodeIfPresent(practiseType.id, forKey: .practiseTypeId)
            try container.encodeIfPresent(interests.filter { $0.isSelected }.map { $0.id }, forKey: .interestsIds)
            try container.encodeIfPresent(contactTelephone, forKey: .contactTelephone)
            try container.encodeIfPresent(contactEmail, forKey: .contactEmail)

            let list: [SocialNetwork] = socialNetworks.compactMap {
                switch $0 {
                case .view(let model):
                    return SocialNetwork(title: model.title, link: model.url?.absoluteString)
                default:
                    return nil
                }

            }
            try container.encodeIfPresent(list, forKey: .socialNetworks)
        }
    }


}
