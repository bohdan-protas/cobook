//
//  UserBallanceAPIModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 14.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct UserBallanceAPIModel: Decodable {
    var totalIncome: Int?
    var totalWithdraw: Int?
    var minWithdraw: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalIncome = "total_income"
        case totalWithdraw = "total_withdraw"
        case minWithdraw = "min_withdraw"
    }
}
