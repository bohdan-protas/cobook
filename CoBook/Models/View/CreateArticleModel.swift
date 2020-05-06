//
//  CreateArticleModel.swift
//  CoBook
//
//  Created by protas on 5/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


struct CreateArticleModel {
    var cardID: Int
    var title: String?
    var body: String?
    var album: AlbumPreview.Item.Model?
    var photos: [FileDataApiModel] = []
}
