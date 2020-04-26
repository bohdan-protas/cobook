//
//  Service.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum Service {

    // MARK: - Creation

    enum CreationItem {
        case gallery
        case sectionSeparator
        case title(text: String)
        case textField(model: TextFieldModel)
        case textView(model: TextFieldModel)
        case checkbox(_ model: CheckboxModel)
    }

    enum CreationSectionAccessoryIndex: Int {
        case header
        case contacts
        case description
    }

    // MARK: - Details

    enum DetailsItem {

    }

    enum DetailsSectionAccessoryIndex: Int {
        case header
    }

    // MARK: - Helpers

    /// Interface for add&view preview items
    enum PreviewListItem {
        case view(model: PreviewListItemModel)
        case add
    }

    /// Model for describing data on preview list items
    struct PreviewListItemModel {
        var imagePath: String?
        var title: String?
        var subtitle: String?
    }

    /// Model for describing data on details screen
    struct CreationDetailsModel {
        var isContractPrice: Bool = false
        var isUseContactsFromSite: Bool = false
        var photos: [EditablePhotoListItem] = []
    }


}
