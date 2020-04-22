//
//  CreateBusinessCardParametersApiModel.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CreateBusinessCardParametersApiModel {
    var id: Int?
    var avatarId: String?
    var backgroundId: String?
    var cityPlaceId: String?
    var regionPlaceId: String?
    var companyName: String?
    var companyWebSite: String?
    var addressPlaceId: String?
    var schedule: String?
    var description: String?
    var practiseTypeId: Int?
    var interestsIds: [Int] = []
    var contactTelephone: String?
    var contactEmail: String?
    var socialNetworks: [SocialNetworkApiModel] = []
    var employeeIds: [String] = []

    init(model: CreateBusinessCard.DetailsModel) {
        self.id = model.cardId
        self.avatarId = model.avatarImage?.id
        self.backgroundId = model.backgroudImage?.id
        self.cityPlaceId = model.city?.googlePlaceId
        self.regionPlaceId = model.region?.googlePlaceId
        self.companyName = model.companyName
        self.companyWebSite = model.companyWebSite
        self.addressPlaceId = model.address?.googlePlaceId
        self.schedule = model.schedule
        self.description = model.description
        self.practiseTypeId = model.practiseType?.id
        self.interestsIds = model.interests.compactMap { $0.id }
        self.contactTelephone = model.contactTelephone
        self.contactEmail = model.companyEmail

        self.socialNetworks = model.socials
            .compactMap {
                switch $0 {
                case .view(let model): return SocialNetworkApiModel(title: model.title, link: model.url?.absoluteString)
                default: return nil
                }
        }

        self.employeeIds = model.employers.compactMap { $0.userId }
    }
}

extension CreateBusinessCardParametersApiModel: Encodable {

    enum CodingKeys: String, CodingKey {
        case id
        case avatarId = "avatar_id"
        case backgroundId = "background_id"
        case cityPlaceId = "city_place_id"
        case regionPlaceId = "region_place_id"
        case companyName = "company_name"
        case companyWebSite = "company_web_site"
        case addressPlaceId = "address_place_id"
        case schedule
        case description
        case practiseTypeId = "practise_type_id"
        case interestsIds = "interests_ids"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case socialNetworks = "social_networks"
        case employeeIds = "employee_ids"

    }

}
