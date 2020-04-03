//
//  RefreshTokenAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct RefreshTokenAPIResponseData {
    var accessToken: String?
}

extension RefreshTokenAPIResponseData: Decodable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }

}
