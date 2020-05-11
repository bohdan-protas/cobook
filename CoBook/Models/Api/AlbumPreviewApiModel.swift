//
//  AlbumPreviewApiModel.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

struct AlbumPreviewApiModel: Decodable {
    var id: Int
    var title: String?
    var avatar: FileDataApiModel?
}
