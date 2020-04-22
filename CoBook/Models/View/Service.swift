//
//  Service.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum Service {

    enum ListItem {
        case view(model: ItemModel)
        case add
    }

    struct ItemModel {
        var imagePath: String?
        var title: String?
        var subtitle: String?
    }

    /// Model for describing data on details screen
    struct DetailsModel {

    }


}
