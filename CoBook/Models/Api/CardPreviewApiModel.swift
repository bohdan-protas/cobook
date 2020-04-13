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

