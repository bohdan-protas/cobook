//
//  NotificationItemAPIModel.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct NotificationItemAPIModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case body
        case createdAt = "created_at"
        case isRead = "read"
        case createdBy = "created_by"
        case photos = "attachments"
    }
    
    var id: Int?
    var body: String?
    var createdAt: Date?
    var isRead: Bool = false
    var createdBy: CardCreatorApiModel?
    var photos: [FileDataApiModel]?
        
}
