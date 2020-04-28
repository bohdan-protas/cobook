//
//  CreateServiceApiModel.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CreateServiceApiModel: Encodable {
    var serviceID: Int?
    var cardID: Int?
    var title: String?
    var header: String?
    var description: String?
    var priceDetails: String?
    var contactTelephone: String?
    var contactEmail: String?
    var photosIds: [String]?

    enum CodingKeys: String, CodingKey {
        case cardID = "card_id"
        case title
        case header
        case description
        case priceDetails = "price_details"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case photosIds = "attachment_ids"
    }
}

struct UpdateServiceApiModel: Encodable {
    var serviceID: Int?
    var cardID: Int?
    var title: String?
    var header: String?
    var description: String?
    var priceDetails: String?
    var contactTelephone: String?
    var contactEmail: String?
    var photosIds: [String]?

    enum CodingKeys: String, CodingKey {
        case serviceID = "id"
        case cardID = "card_id"
        case title
        case header
        case description
        case priceDetails = "price_details"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case photosIds = "attachment_ids"
    }


}
