//
//  ServicePreviewApiModel.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct ServicePreviewApiModel: Decodable {
    var id: Int?
    var title: String?
    var avatar: FileDataApiModel?
    var contactTelephone: TelephoneApiModel?
    var description: String?
    var header: String?
    var priceDetails: String?
    var contactEmail: EmailApiModel?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case avatar
        case description
        case header
        case contactTelephone = "contact_telephone"
        case priceDetails = "price_details"
        case contactEmail = "contact_email"
    }

}
