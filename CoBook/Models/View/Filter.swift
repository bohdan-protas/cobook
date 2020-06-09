//
//  Filter.swift
//  CoBook
//
//  Created by protas on 6/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation


enum Filter {

    enum Items {
        case title(model: ActionTitleModel)
        case practiceItem(model: PracticeModel)
    }

    enum SectionAccessoryIndex: Int {
        case interests
        case practicies
    }


}
