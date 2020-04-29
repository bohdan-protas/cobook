//
//  ProductPreviewApiModel.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


struct ProductPreviewApiModel: Decodable {
    var id: Int
    var showroom: Int
    var title: String?
    var image: FileDataApiModel?
    var descrTitle: String?
    var descrBody: String?
    var price: String?
    var contactTelephone: TelephoneApiModel?
    var contactEmail: EmailApiModel?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image = "avatar"
        case descrTitle = "header"
        case descrBody = "description"
        case price = "price_details"
        case showroom = "workshop"
        case contactTelephone = "contact_telephone"
        case contactEmail = "contact_email"
    }
}
