//
//  BusinessCardDetails.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum BusinessCardDetails {

    enum Cell {
        case title(text: String)
        case sectionHeader
        case companyDescription(model: TitleDescrModel?)
        case userInfo(model: BusinessCardDetails.HeaderInfoModel?)
        case getInTouch
        case socialList
        case addressInfo(model: AddressInfoCellModel)
        case map(centerPlaceID: String)
        case mapDirection
        case employee(model: EmployeeModel?)
        case contacts(model: ContactsModel?)
        case service(model: Service.PreviewListItem)
        case addProduct
        case productSection(model: ProductPreviewSectionModel)
        case postPreview(model: AlbumPreview.Section?)
    }

    struct HeaderInfoModel {
        var name: String?
        var avatartImagePath: String?
        var bgimagePath: String?
        var profession: String?
        var telephoneNumber: String?
        var websiteAddress: String?
    }

    enum SectionAccessoryIndex: Int {
        case userHeader, postPreview, cardDetails
    }

    enum BarSectionsTypeIndex: Int {
        case general, services, products, team, contacts
    }

    enum PostPreviewDataSourceID: String {
        case albumPreviews
    }

}
