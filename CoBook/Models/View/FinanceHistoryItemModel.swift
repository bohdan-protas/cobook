//
//  FinanceHistoryItemModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 02.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct FinanceHistoryItemModel {
    var id: Int?
    var type: CardType?
    var telephone: String?
    var cardCreator: CardCreatorApiModel?
    var companyName: String?
    var avatarURL: String?
    var practiceType: String?
    var moneyIncome: Int?
}
