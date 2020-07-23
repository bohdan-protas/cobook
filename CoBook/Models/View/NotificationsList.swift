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
        var title: String?
        var body: String?
        var createdAt: Date?
        var creator: CardCreatorApiModel?
        var photos: [String]?
    }
    
}
