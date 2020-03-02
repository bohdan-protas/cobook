//
//  BaseApiModel.swift
//  CoBook
//
//  Created by protas on 2/24/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum APIRequestStatus: String, Decodable {
    case ok
    case error
}

// MARK: - VoidResponseData
/// described void response from server
struct VoidResponseData: Decodable {
}

// MAKR: - APIResponse
/// Used for unique data
struct APIResponse<EmbadedData: Decodable>: Decodable {
    /// Status of request returned from server
    var status: APIRequestStatus

    /// Error identifier. Null if success
    var errorId: String?

    /// Error message localized based on localization header
    var errorLocalizadMessage: String?

    ///Internal dev error description
    var errorDescription: String?

    /// Response payload
    var data: EmbadedData?

    enum CodingKeys: String, CodingKey {
        case data
        case status
        case errorId = "error_id"
        case errorLocalizadMessage = "error_localized_message"
        case errorDescription = "error_description"
    }
}


