//
//  CardPreviewApiModel.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - CardPreviewApiModel
struct CardPreviewApiModel: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case avatar
        case telephone
        case email
        case practiceType = "practice_type"
        case company
    }

    var id: Int
    var type: CardType
    var avatar: FileDataApiModel?
    var telephone: TelephoneApiModel?
    var email: EmailApiModel?
    var practiceType: PracticeTypeApiModel?
    var company: CompanyApiModel?
}

struct EmployApiModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
        case position
        case telephone
        case practiceType = "practice_type"
    }

    var id: String?
    var firstName: String?
    var lastName: String?
    var avatar: FileDataApiModel?
    var position: String?
    var telephone: TelephoneApiModel?
    var practiceType: PracticeTypeApiModel?
}
