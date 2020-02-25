//
//  FinishRegistratrationAPIResponseData.swift
//  CoBook
//
//  Created by protas on 2/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct FinishRegistratrationAPIResponseData {
    var userID: String
    var assessToken: String
    var refreshToken: String
}

extension FinishRegistratrationAPIResponseData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case assessToken = "access_token"
        case refreshToken = "refresh_token"
    }


}

