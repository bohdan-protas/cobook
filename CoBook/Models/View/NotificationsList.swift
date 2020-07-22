//
//  NotificationsList.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum NotificationsList {
    
    enum Item {
        case notification(model: Model)
    }
    
    struct Model {
        var id: Int?
        var createdAt: Date?
        var isRead: Bool = false
        var creator: CardCreatorApiModel?
        var photos: [String]?
    }
    
}
