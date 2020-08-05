//
//  PricingInfoAPIModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 05.08.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct PricesInfoAPIModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case businessCard = "business_card"
        case franchise
        case leader
    }
    
    var businessCard: PriceInfoAPIModel?
    var franchise: PriceInfoAPIModel?
    var leader: PriceInfoAPIModel
}

struct PriceInfoAPIModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case value = "price"
        case currency
    }
    
    var type: String?
    var value: Double?
    var currency: String?
}
