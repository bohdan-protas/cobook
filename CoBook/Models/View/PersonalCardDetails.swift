//
//  PersonalCardDetails.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum PersonalCardDetails {

    struct Section {
        var items: [Item]
    }

    enum Item {
        case title(text: String)
        case userInfo(model: CardDetailsApiModel)
        case getInTouch
        case socialList(list: [Social.ListItem])
        case sectionHeader
    }


}

