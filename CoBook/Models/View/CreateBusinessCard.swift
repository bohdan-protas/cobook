//
//  CreateBusinessCard.swift
//  CoBook
//
//  Created by protas on 4/1/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CreateBusinessCard {

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
        case practice
        case city
        case region
        case address
    }

    struct DetailsModel {
        var avatarImage: FileDataApiModel?
        var backgroudImage: FileDataApiModel?

        var companyName: String?
        var practiseType: PracticeModel?
        var contactTelephone: String?
        var companyWebSite: String?

        var city: PlaceModel?
        var region: PlaceModel?
        var address: PlaceModel?
        var schedule: String?

        var interests: [InterestModel] = []
        var socials: [Social.ListItem] = []
        var practices: [PracticeModel] = []

//        init(with model: CardDetailsApiModel) {
//            self.avatarImage = model.avatar
//
//            self.city = PlaceModel(googlePlaceId: model.city?.googlePlaceId, name: model.city?.name)
//            self.region = PlaceModel(googlePlaceId: model.region?.googlePlaceId, name: model.city?.name)
//            self.address = PlaceModel(googlePlaceId: model.address?.googlePlaceId, name: model.city?.name)
//
//            self.practiseType = PracticeType(id: model.practiceType?.id, title: model.practiceType?.title)
//            self.interests = (model.interests ?? []).compactMap { InterestItem(id: $0.id, title: $0.title, isSelected: true) }
//            self.contactTelephone = model.contactTelephone?.number
//            self.contactEmail = model.contactEmail?.address
//            self.socialNetworks = model.socialNetworks ?? []//(model.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
//        }

    }

}

//enum CodingKeys: String, CodingKey {
//    case avatarId  = "avatar_id"
//    case bgImageId  = "background_id"
//    case cityPlaceId = "city_place_id"
//    case regionPlaceId = "region_place_id"
//    case companyName = "company_name"
//    case companyWebSite = "company_web_site"
//    case addressPlaceId = "address_place_id"
//    case schedule  = "schedule"
//    case practiseTypeId = "practise_type_id"
//    case interestsIds = "interests_ids"
//    case contactTelephone = "contact_telephone"
//    case contactEmail = "contact_email"
//    case socialNetworks = "social_networks"
//    case employeeIds = "employee_ids"
//}
//
//
//
//func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encodeIfPresent(avatarId, forKey: .avatarId)
//    try container.encodeIfPresent(bgImageId, forKey: .bgImageId)
//    try container.encodeIfPresent(city.googlePlaceId, forKey: .cityPlaceId)
//    try container.encodeIfPresent(region.googlePlaceId, forKey: .regionPlaceId)
//    try container.encodeIfPresent(companyName, forKey: .companyName)
//    try container.encodeIfPresent(companyWebSite, forKey: .companyWebSite)
//    try container.encodeIfPresent(addressPlaceId, forKey: .addressPlaceId)
//    try container.encodeIfPresent(schedule, forKey: .schedule)
//    try container.encodeIfPresent(practiseType.id, forKey: .practiseTypeId)
//    try container.encodeIfPresent(interests.filter { $0.isSelected }.map { $0.id }, forKey: .interestsIds)
//    try container.encodeIfPresent(contactTelephone, forKey: .contactTelephone)
//    try container.encodeIfPresent(contactEmail, forKey: .contactEmail)
//
//    let list: [SocialNetwork] = socialNetworks.compactMap {
//        switch $0 {
//        case .view(let model):
//            return SocialNetwork(title: model.title, link: model.url?.absoluteString)
//        default:
//            return nil
//        }
//
//    }
//    try container.encodeIfPresent(list, forKey: .socialNetworks)
//    try container.encodeIfPresent(employeeIds, forKey: .employeeIds)
//}
