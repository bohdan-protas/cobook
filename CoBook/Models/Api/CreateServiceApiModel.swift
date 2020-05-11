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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceID, forKey: .cardID)
        try container.encode(cardID, forKey: .cardID)
        try container.encode(title, forKey: .title)
        try container.encode(header, forKey: .header)
        try container.encode(description, forKey: .description)
        try container.encode(priceDetails, forKey: .priceDetails)
        try container.encode(contactTelephone, forKey: .contactTelephone)
        try container.encode(contactEmail, forKey: .contactEmail)
        try container.encode(photosIds, forKey: .photosIds)
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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serviceID, forKey: .serviceID)
        try container.encode(cardID, forKey: .cardID)
        try container.encode(title, forKey: .title)
        try container.encode(header, forKey: .header)
        try container.encode(description, forKey: .description)
        try container.encode(priceDetails, forKey: .priceDetails)
        try container.encode(contactTelephone, forKey: .contactTelephone)
        try container.encode(contactEmail, forKey: .contactEmail)
        try container.encode(photosIds, forKey: .photosIds)
    }


}
