//
//  ArticlePreviewAPIModel.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct ArticlePreviewAPIModel: Decodable {
    var id: Int
    var title: String?
    var avatar: FileDataApiModel?
}
