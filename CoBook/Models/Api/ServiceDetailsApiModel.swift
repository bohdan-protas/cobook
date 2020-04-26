//
//  ServiceDetailsApiModel.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct ServiceDetailsApiModel: Decodable {
    var id: Int?
    var title: String?
    var description: String?
    var header: String?
    var contactTelephone: TelephoneApiModel?
    var priceDetails: String?
    var contactEmail: EmailApiModel?
    var photos: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case header
        case contactTelephone = "contact_telephone"
        case priceDetails = "price_details"
        case contactEmail = "contact_email"
        case photos = "attachments"
    }

}
