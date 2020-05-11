//
//  ProductDetails.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum ProductDetails {

    enum Cell {
        case companyHeader(model: CompanyPreviewHeaderModel)
        case gallery
        case getInTouch
        case sectionSeparator
        case serviceHeaderDescr(model: TitleDescrModel?)
        case serviceDescription(model: TitleDescrModel?)
    }

    enum SectionAccessoryIndex: Int {
        case header, description
    }

    struct DetailsModel {
        var id: Int?
        var title: String?
        var showroom: Int?
        var photos: [EditablePhotoListItem] = []
        var companyName: String?
        var companyAvatar: String?
        var price: String?
        var telephoneNumber: String?
        var email: String?
        var descriptionTitle: String?
        var desctiptionBody: String?

    }

}
