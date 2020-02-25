//
//  BaseApiModel.swift
//  CoBook
//
//  Created by protas on 2/24/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum APIRequestStatus: String, Codable {
    case ok
    case error
}

/// Used for unique data
struct APIResponse<EmbadedData: Decodable>: Decodable {
    var status: APIRequestStatus
    var errorId: String?
    var errorLocalizadMessage: String?
    var errorDescription: String?
    var data: EmbadedData?

    enum CodingKeys: String, CodingKey {
        case data
        case status
        case errorId = "error_id"
        case errorLocalizadMessage = "error_localized_message"
        case errorDescription = "error_description"
    }
}


