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

    enum CreationCell {
        case gallery
        case sectionSeparator
        case title(text: String)
        case textField(model: TextFieldModel)
        case textView(model: TextFieldModel)
        case checkbox(model: CheckboxModel)
        case companyHeader(model: CompanyPreviewHeaderModel)
    }

    enum CreationSectionAccessoryIndex: Int {
        case header
        case contacts
        case description
    }

    struct CreationDetailsModel {
        var cardID: Int
        var photos: [EditablePhotoListItem] = []
        var companyName: String?
        var companyAvatar: String?
        var serviceName: String?
        var price: String?
        var isUseContactsFromSite: Bool = false
        var telephoneNumber: String?
        var email: String?
        var isContractPrice: Bool = false
        var descriptionTitle: String?
        var desctiptionBody: String?
    }

    // MARK: - Details

    enum DetailsCell {
        case companyHeader(model: CompanyPreviewHeaderModel)
        case gallery
        case getInTouch
        case sectionSeparator
        case serviceHeaderDescr(model: TitleDescrModel?)
        case serviceDescription(model: TitleDescrModel?)
    }

    enum DetailsSectionAccessoryIndex: Int {
        case header, description
    }

    struct DetailsViewModel {
        var title: String?
        var photos: [EditablePhotoListItem] = []
        var companyName: String?
        var companyAvatar: String?
        var serviceName: String?
        var price: String?
        var telephoneNumber: String?
        var email: String?
        var descriptionTitle: String?
        var desctiptionBody: String?

    }


    // MARK: - Preview

    enum PreviewListItem {
        case view(model: PreviewModel)
        case add
    }

    struct PreviewModel {
        var id: Int?
        var name: String?
        var avatarPath: String?
        var price: String
        var descriptionTitle: String?
        var descriptionHeader: String?
        var contactTelephone: String?
        var contactEmail: String?
    }



}
