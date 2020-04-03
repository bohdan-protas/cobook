//
//  CreateBusinessCard.swift
//  CoBook
//
//  Created by protas on 4/1/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

enum CreateBusinessCard {

    enum Cell {
        case backgroundImageManagment(model: BackgroundManagmentImageCellModel)
        case avatarManagment(model: CardAvatarManagmentCellModel)
        case title(text: String)
        case sectionHeader
        case textField(model: TextFieldModel)
        case actionField(model: ActionFieldModel)
        case textView(model: TextFieldModel)
        case socials
        case interests
    }

    enum ActionType: String {
        case practice
        case city
        case region
        case address
    }

    struct DetailsModel {
        var avatarImage: FileDataApiModel?
        var backgroudImage: FileDataApiModel?

        var companyName: String?
        var practiseType: PracticeModel?
        var contactTelephone: String?
        var companyWebSite: String?

        var city: PlaceModel?
        var region: PlaceModel?
        var address: PlaceModel?
        var schedule: String?

        var interests: [InterestModel] = []
        var socials: [Social.ListItem] = []
        var practices: [PracticeModel] = []
    }

}


