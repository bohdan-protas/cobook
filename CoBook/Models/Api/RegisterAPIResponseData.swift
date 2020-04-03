//
//  FinishRegistratrationAPIResponseData.swift
//  CoBook
//
//  Created by protas on 2/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct RegisterAPIResponseData {
    var profile: ProfileApiModel?
    var assessToken: String?
    var refreshToken: String?
}

extension RegisterAPIResponseData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case profile
        case assessToken = "access_token"
        case refreshToken = "refresh_token"
    }


}

