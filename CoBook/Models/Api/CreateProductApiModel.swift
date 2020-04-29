//
//  CreateProductApiModel.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CreateProductApiModel: Encodable {
    var cardID: Int?
    var title: String?
    var header: String?
    var description: String?
    var priceDetails: String?
    var contactTelephone: String?
    var contactEmail: String?
    var photosIds: [String]?
    var showroom: Int?

    enum CodingKeys: String, CodingKey {
        case cardID = "card_id"
        case title
        case header
        case description
        case priceDetails = "price_details"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case photosIds = "attachment_ids"
        case showroom = "workshop"
    }
}

struct UpdateProductApiModel: Encodable {
    var productID: Int?
    var cardID: Int?
    var title: String?
    var header: String?
    var description: String?
    var priceDetails: String?
    var contactTelephone: String?
    var contactEmail: String?
    var photosIds: [String]?
    var showroom: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "id"
        case cardID = "card_id"
        case title
        case header
        case description
        case priceDetails = "price_details"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
        case photosIds = "attachment_ids"
        case showroom = "workshop"
    }
}
