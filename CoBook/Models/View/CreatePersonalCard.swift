//
//  Card.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum CreatePersonalCard {

    enum Cell {
        case avatarManagment(model: CardAvatarManagmentCellModel)
        case title(text: String)
        case sectionHeader
        case textField(model: TextFieldModel)
        case actionField(model: ActionFieldModel)
        case textView(model: TextFieldModel)
        case socials
        case interests
    }

    enum ActionType: String {
        case activityType
        case placeOfLiving
        case activityRegion
    }

    struct DetailsModel {
        var avatarImage: FileDataApiModel?

        var position: String?
        var practiseType: PracticeModel?
        var city: PlaceModel?
        var region: PlaceModel?
        var description: String?

        var contactTelephone: String?
        var contactEmail: String?

        var interests: [InterestModel] = []
        var socials: [Social.ListItem] = []
        var practices: [PracticeModel] = []
    }



}

    //    struct CreatePersonalCardViewModel: Encodable {
    //        var avatarId: String?
    //        var avatarUrl: String?
//        var city: PlaceApiModel = PlaceApiModel()
//        var region: PlaceApiModel = PlaceApiModel()
//        var position: String?
//        var description: String?
//        var practiseType: PracticeModel = PracticeModel()
//        var interests:  [InterestModel] = []
//        var contactTelephone: String?
//        var contactEmail: String?
//        var practices:  [PracticeModel] = []
//        var socialNetworks: [Social.ListItem] = []
//
//        enum CodingKeys: String, CodingKey {
//            case avatarId = "avatar_id"
//            case cityPlaceId = "city_place_id"
//            case regionPlaceId = "region_place_id"
//            case position
//            case description
//            case practiseTypeId = "practise_type_id"
//            case interestsIds = "interests_ids"
//            case contactTelephone = "contact_telephone"
//            case contactEmail = "contact_email"
//            case socialNetworks = "social_networks"
//        }
//
//        init() {
//        }
//
//        init(with model: CardDetailsApiModel) {
//            self.avatarId = model.avatar?.id
//            self.avatarUrl = model.avatar?.sourceUrl
//            self.city = PlaceApiModel(id: model.city?.id, googlePlaceId: model.city?.googlePlaceId, name: model.city?.name)
//            self.region = PlaceApiModel(id: model.region?.id, googlePlaceId: model.region?.googlePlaceId, name: model.region?.name)
//            self.position = model.position
//            self.description = model.description
//            self.practiseType = PracticeType(id: model.practiceType?.id, title: model.practiceType?.title)
//            self.interests = (model.interests ?? []).compactMap { InterestModel(id: $0.id, title: $0.title, isSelected: true) }
//            self.contactTelephone = model.contactTelephone?.number
//            self.contactEmail = model.contactEmail?.address
//            self.socialNetworks = (model.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
//        }
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encodeIfPresent(avatarId, forKey: .avatarId)
//            try container.encodeIfPresent(city.googlePlaceId, forKey: .cityPlaceId)
//            try container.encodeIfPresent(region.googlePlaceId, forKey: .regionPlaceId)
//            try container.encodeIfPresent(position, forKey: .position)
//            try container.encodeIfPresent(description, forKey: .description)
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
//        }
//    }




