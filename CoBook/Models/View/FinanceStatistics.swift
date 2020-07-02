//
//  FinanceStatistics.swift
//  CoBook
//
//  Created by Bogdan Protas on 02.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum FinanceStatistics {
    
    enum Section: Int {
        case rating
    }
    
    enum Item {
        case ratingItem(model: FinanceHistoryItemModel)
    }
    
}

enum Financies {
    
    enum Item {
        case bonusHistoryItem(model: FinanceHistoryItemModel)
    }
    
}
