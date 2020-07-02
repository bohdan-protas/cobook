//
//  ReferalStatsAPIModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 02.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct ReferalStatsAPIModel: Decodable {
    var downloadCount: String?
    var createdBusinessCardCount: String?
    
    enum CodingKeys: String, CodingKey {
        case downloadCount = "downloads_count"
        case createdBusinessCardCount = "created_business_card_count"
    }
}

