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
        case cardItem(model: CardItemViewModel)
        case map
        case postPreview(model: PostPreview.Section?)
    }

    enum BarSectionsTypeIndex: Int {
        case allCards, personalCards, businessCards, inMyRegionCards
    }

    enum SectionAccessoryIndex: Int {
        case posts
        case cards
    }

    enum SearchSectionAccessoryIndex: Int {
        case header, barSections
    }

    static let postsDataSourceID: String = "postsDataSourceID"

    struct MapCellModel {
    
    }

}
