//
//  EmployApiModel.swift
//  CoBook
//
//  Created by protas on 4/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct EmployApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case cardId = "id"
        case userId
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
        case position
        case telephone
        case practiceType = "practice_type"
    }

    var cardId: Int?
    var userId: String?
    var firstName: String?
    var lastName: String?
    var avatar: FileDataApiModel?
    var position: String?
    var telephone: TelephoneApiModel?
    var practiceType: PracticeTypeApiModel?
}
