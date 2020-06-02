//
//  PostPreview.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum PostPreview {

    struct Section {
        var dataSourceID: String?
        var items: [Item] = []
    }

    enum Item {

        struct Model {
            var albumID: Int?
            var articleID: Int?
            var isSelected = false
            var title: String?
            var avatarPath: String?
            var avatarID: String?
        }

        case add(title: String?, imagePath: String?)
        case view(_ model: Model)
        case showMore
    }


}
