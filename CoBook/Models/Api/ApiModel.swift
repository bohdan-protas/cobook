//
//  ApiModel.swift
//  CoBook
//
//  Created by protas on 4/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct InterestApiModel: Decodable {
    var id: Int?
    var title: String?
}

struct SocialNetworkApiModel: Codable {
    var title: String?
    var link: String?
}

struct PlaceApiModel: Decodable {
    var id: Int?
    var googlePlaceId: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case googlePlaceId = "place_id"
        case name
    }
}

struct CardCreatorApiModel: Decodable {
    var id: String
    var firstName: String?
    var lastName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct CompanyApiModel: Decodable {
    var id: Int
    var name: String?
}

struct TelephoneApiModel: Codable {
    var id: Int?
    var number: String?
}

struct EmailApiModel: Codable {
    var id: Int?
    var address: String?
}

enum CardType: String, Codable {
    case personal
    case business
}

struct PracticeTypeApiModel: Codable {
    var id: Int
    var title: String?
}

// MARK: - Card
struct CardPreviewApiModel: Codable {

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
    var avatar: FileDataApiModel?
    var telephone: TelephoneApiModel?
    var email: EmailApiModel?
    var practiceType: PracticeTypeApiModel?
}

// MARK: - Profile
struct ProfileApiModel: Codable {

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
    var telephone: TelephoneApiModel = TelephoneApiModel()
    var email: EmailApiModel = EmailApiModel()
    var personalCardsList: [CardPreviewApiModel]?
}


