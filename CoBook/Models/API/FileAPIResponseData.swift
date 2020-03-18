//
//  FileAPIResponseData.swift
//  CoBook
//
//  Created by protas on 3/18/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct FileAPIResponseData {
    var storageKey: String?
    /// UUID represented attachment identifier
    var id: String
    var createdAt: String?  // 2020-03-18T20:30:59.828Z
    var subtype: String?    // png
    var type: String?       // image
    var ownerId: String?
    /// Path to download file
    var sourceUrl: String?

}

extension FileAPIResponseData: Decodable {
    enum CodingKeys: String, CodingKey {
        case storageKey = "storage_key"
        case id
        case createdAt  = "createdAt"
        case subtype
        case type
        case ownerId    = "owner_id"
        case sourceUrl  = "source_url"
    }
}

