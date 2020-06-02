//
//  PersonalCardDetails.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum PersonalCardDetails {

    enum Cell {
        case sectionHeader
        case title(text: String)
        case actionTitle(model: ActionTitleModel)
        case personDescription(model: TitleDescrModel?)
        case userInfo(model: CardDetailsApiModel?)
        case getInTouch
        case socialList
        case postPreview(model: PostPreview.Section?)
    }

    enum DataSourceID: String {
        case albumPreviews
    }

}

