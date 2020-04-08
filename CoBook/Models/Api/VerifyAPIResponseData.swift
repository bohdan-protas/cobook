//
//  VerifyAPIResponseData.swift
//  CoBook
//
//  Created by protas on 2/25/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct VerifyAPIResponseData {
    var isSuccess: Bool
}

extension VerifyAPIResponseData: Decodable {

    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSuccess = try container.decodeIfPresent(Bool.self, forKey: .isSuccess) ?? false
    }

    
}
