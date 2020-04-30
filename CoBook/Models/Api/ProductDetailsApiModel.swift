//
//  ProductDetailsApiModel.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


struct ProductDetailsApiModel: Decodable {
    var id: Int?
    var title: String?
    var showroom: Int?
    var description: String?
    var priceDetails: String?
    var header: String?
    var contactTelephone: TelephoneApiModel?
    var contactEmail: EmailApiModel?
    var photos: [FileDataApiModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case showroom = "workshop"
        case description
        case header
        case contactTelephone = "contact_telephone"
        case priceDetails = "price_details"
        case contactEmail = "contact_email"
        case photos = "attachments"
    }

}
