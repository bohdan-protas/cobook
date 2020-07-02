//
//  CardBonusApiModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct CardBonusApiModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case cardCreator = "created_by"
        case company
        case avatar
        case practiceType = "practice_type"
        case moneyIncome = "value"
    }
    
    var id: Int?
    var type: CardType?
    var cardCreator: CardCreatorApiModel?
    var company: CompanyApiModel?
    var avatar: FileDataApiModel?
    var practiceType: PracticeTypeApiModel?
    var moneyIncome: Int?
}
