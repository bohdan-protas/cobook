//
//  User.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var userID: String?
    var firstName: String?
    var lastName: String?
    var telephone: Telephone
    var email: Email

    struct Telephone: Codable {
        var id: String?
        var number: String?
    }

    struct Email: Codable {
        var id: String?
        var address: String?
    }

    enum CodingKeys: String, CodingKey {
        case userID     = "id"
        case firstName  = "first_name"
        case lastName   = "last_name"
        case telephone
        case email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(String.self, forKey: .userID)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        telephone = try container.decodeIfPresent(Telephone.self, forKey: .telephone) ?? Telephone(id: nil, number: nil)
        email = try container.decodeIfPresent(Email.self, forKey: .email) ?? Email(id: nil, address: nil)
    }

    init(userID: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         telephone: Telephone = Telephone(id: nil, number: nil),
         email: Email = Email(id: nil, address: nil)) {

        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.telephone = telephone
        self.email = email
    }


}

