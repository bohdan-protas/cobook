//
//  Model.swift
//  CoBook
//
//  Created by protas on 4/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct TextFieldModel {
    var isEnabled: Bool = true
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
    var imageData: Data?
}

struct BackgroundManagmentImageCellModel {
    var imagePath: String?
    var imageData: Data?
}

struct CardPreviewModel: Equatable {
    var id: String?
    var image: String?
    var firstName: String?
    var lastName: String?
    var profession: String?
    var telephone: String?
}

struct AddressInfoCellModel {
    var mainAddress: String?
    var subAdress: String?
    var schedule: String?
}

struct ContactsModel {
    var telNumber: String?
    var website: String?
    var email: String?
}

struct CheckboxModel {
    var title: String
    var isSelected: Bool
    var handler: ((_ button: UIButton) -> Void)? = nil
}
