//
//  User.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct Telephone: Codable {
    var id: String?
    var number: String?
}

struct Email: Codable {
    var id: String?
    var address: String?
}

struct Profile: Codable {

    enum CodingKeys: String, CodingKey {
        case userId     = "id"
        case firstName  = "first_name"
        case lastName   = "last_name"
        case telephone
        case email
    }

    var userId: String?
    var firstName: String?
    var lastName: String?
    var telephone: Telephone = Telephone()
    var email: Email = Email()
}

