//
//  CreateProduct.swift
//  CoBook
//
//  Created by protas on 4/28/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CreateProduct {

    enum Cell {
        case companyHeader(model: CompanyPreviewHeaderModel)
        case gallery
        case sectionSeparator
        case title(text: String)
        case textField(model: TextFieldModel)
        case textView(model: TextFieldModel)
        case checkbox(model: CheckboxModel)
    }

    enum SectionAccessoryIndex: Int {
        case header
        case contacts
        case description
    }

    struct DetailsModel {

    }


}
