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

struct CompanyApiModel: Codable {
    var id: Int?
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




