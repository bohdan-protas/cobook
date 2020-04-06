//
//  ProfileApiModel.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - Profile
struct ProfileApiModel: Codable {

    enum CodingKeys: String, CodingKey {
        case userId     = "id"
        case firstName  = "first_name"
        case lastName   = "last_name"
        case telephone
        case email
        case cardsPreviews = "cards_previews"
    }

    var userId: String?
    var firstName: String?
    var lastName: String?
    var telephone: TelephoneApiModel = TelephoneApiModel()
    var email: EmailApiModel = EmailApiModel()
    var cardsPreviews: [CardPreviewApiModel]?
}
