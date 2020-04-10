//
//  CardsOverview.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CardsOverview {

    enum Items {
        case cardItem(model: CardItemViewModel?)
        case map
    }

    enum BarSectionsTypeIndex: Int {
        case allCards, personalCards, businessCards, inMyRegionCards
    }


}
