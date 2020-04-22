//
//  Service.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum Service {

    enum EditItem {

    }

    enum CreateItem {

    }

    /// Interface for add&view preview items
    enum PreviewListItem {
        case view(model: PreviewListItemModel)
        case add
    }

    /// Model for describing data on preview list items
    struct PreviewListItemModel {
        var imagePath: String?
        var title: String?
        var subtitle: String?
    }

    /// Model for describing data on details screen
    struct DetailsModel {

    }


}
