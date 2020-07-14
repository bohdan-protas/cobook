//
//  LeaderboardStatAPIModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 14.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct LeaderboardStatAPIModel: Decodable {
    var id: String?
    var lastName: String?
    var firstName: String?
    var score: Int?
    var avatar: FileDataApiModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case firstName = "first_name"
        case score
        case avatar
    }
}
