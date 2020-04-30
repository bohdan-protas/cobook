//
//  PostPreview.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum PostPreview {

    struct Model {
        var title: String?
        var imagePath: String?
        var image: UIImage?
    }

    case add(_ model: Model)
    case view(_ model: Model)
    case showMore(_ model: Model)
}
