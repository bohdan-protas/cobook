//
//  WithdrawStatus.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum WithdrawStatus: String, Decodable {
    case pending
    case approved
    case rejected
    case cancelled
}

struct WithdrawRecord: Decodable {
    var id: Int?
    var userID: String?
    var value: Int?
    var status: WithdrawStatus?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case value
        case status
        case createdAt = "created_at"
    }
}
