//
//  Model.swift
//  CoBook
//
//  Created by protas on 4/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

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

struct PracticeModel: Codable {
    var id: Int?
    var title: String?
    var isSelected: Bool = false
}

struct TagModel {
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
    var publishStatus: CardPublishStatus?
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

struct CompanyPreviewHeaderModel {
    var title: String?
    var image: String?
}

struct TitleDescrModel {
    var title: String?
    var descr: String?
    var isDescriptionExpanded: Bool = true
}

struct ProductPreviewSectionModel {
    var showroom: Int
    var headerTitle: String?
    var productPreviewItems: [ProductPreviewItemModel] = []
}

struct ProductPreviewItemModel {
    var showroom: Int
    var name: String?
    var price: String?
    var image: String?
    var productID: Int
    var cardID: Int
    var companyName: String?
    var companyAvatar: String?
    var isUserOwner: Bool
}

struct ArticlePreviewModel {
    var id: Int
    var title: String?
    var image: String?
}

struct FilterItemModel {
    var id: Int?
    var title: String?
    var isSelected: Bool = false
}

struct UserFilters: Codable {
    //var interests: [Int] = []
    var practicies: [PracticeModel] = []
}

struct DynamicLinkContainer: Codable {
    let matchType: UInt?
    let url: URL?

    init(dynamicLink: DynamicLink) {
        self.matchType = dynamicLink.matchType.rawValue
        self.url = dynamicLink.url
    }

}

struct PlaceholderCellModel {
    var image: UIImage?
    var title: String?
    var subtitle: String?
}

struct ButtonCellModel {
    var title: String?
    var action: (() -> Void)?
}

struct PublishCellModel {
    var titleText: String?
    var subtitleText: String?
    var actionTitle: String?
    var action: (() -> Void)?
}
