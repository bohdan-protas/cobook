//
//  User.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - Email
struct Telephone: Codable {
    var id: Int?
    var number: String?
}

// MARK: - Email
struct Email: Codable {
    var id: Int?
    var address: String?
}

enum CardType: String, Codable {
    case personal
    case business
}

struct PracticeType: Codable {
    var id: Int
    var title: String?
}

// MARK: - Card
struct CardPreview: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case avatar
        case telephone
        case email
        case practiceType = "practice_type"
    }

    var id: Int
    var type: CardType
    var avatar: FileAPIResponseData?
    var telephone: Telephone?
    var email: Email?
    var practiceType: PracticeType?
}

// MARK: - Profile
struct Profile: Codable {

    enum CodingKeys: String, CodingKey {
        case userId     = "id"
        case firstName  = "first_name"
        case lastName   = "last_name"
        case telephone
        case email
        case personalCardsList = "cards_previews"
    }

    var userId: String?
    var firstName: String?
    var lastName: String?
    var telephone: Telephone = Telephone()
    var email: Email = Email()
    var personalCardsList: [CardPreview]?
}





