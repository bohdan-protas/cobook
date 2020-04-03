//
//  Model.swift
//  CoBook
//
//  Created by protas on 4/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct TextFieldModel {
    var text: String? = nil
    var placeholder: String? = nil
    var associatedKeyPath: AnyKeyPath? = nil
    var keyboardType: UIKeyboardType = .default
}

struct ActionFieldModel {
    var text: String?
    var placeholder: String?
    var actionTypeId: String?
}

struct PracticeModel {
    var id: Int?
    var title: String?
}

struct InterestModel {
    var id: Int?
    var title: String?
    var isSelected: Bool = false
}

struct PlaceModel {
    var googlePlaceId: String?
    var name: String?
}

struct CardAvatarManagmentCellModel {
    let sourceType: CardAvatarPhotoManagmentTableViewCell.SourceType
    let imagePath: String?
}

struct BackgroundManagmentImageCellModel {
    var imagePath: String?
}
